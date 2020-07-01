# typed: strict
require 'sorbet-runtime'

class AddProductBacklogItemUsecase
  extend T::Sig

  sig {void}
  def initialize
    @pbi_repository = T.let(ProductBacklogItemRepository::AR, Product::BacklogItemRepository)
    @order_repository = T.let(ProductBacklogItemOrderRepository::AR, Product::BacklogItemOrderRepository)
  end

  sig {params(product_id: Product::ProductId, content: Product::BacklogItemContent).returns(Product::BacklogItemId)}
  def perform(product_id, content)
    pbi = Product::BacklogItem.create(content)

    order = find_order(product_id)
    order.append(pbi)

    ApplicationRecord.transaction do
      @pbi_repository.add(pbi)
      @order_repository.update(order)
    end

    pbi.id
  end

  private

  sig {params(product_id: Product::ProductId).returns(Product::BacklogItemOrder)}
  def find_order(product_id)
    order = @order_repository.find_by_product_id(product_id)
    return Product::BacklogItemOrder.create(product_id) unless order

    order
  end
end
