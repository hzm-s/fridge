# typed: strict
require 'sorbet-runtime'

class AddProductBacklogItemUsecase
  extend T::Sig

  sig {void}
  def initialize
    @pbi_repository = T.let(ProductBacklogItemRepository::AR, Pbi::ItemRepository)
    @order_repository = T.let(ProductBacklogOrderRepository::AR, Pbi::OrderRepository)
  end

  sig {params(product_id: Product::ProductId, content: Pbi::Content).returns(Pbi::ItemId)}
  def perform(product_id, content)
    pbi = Pbi::Item.create(product_id, content)

    order = find_order(product_id)
    order.append(pbi)

    ApplicationRecord.transaction do
      @pbi_repository.add(pbi)
      @order_repository.update(order)
    end

    pbi.id
  end

  private

  sig {params(product_id: Product::ProductId).returns(Pbi::Order)}
  def find_order(product_id)
    order = @order_repository.find_by_product_id(product_id)
    return Pbi::Order.create(product_id) unless order

    order
  end
end
