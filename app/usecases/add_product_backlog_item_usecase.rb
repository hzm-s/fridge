# typed: strict
require 'sorbet-runtime'

class AddProductBacklogItemUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @pbi_repository = T.let(ProductBacklogItemRepository::AR, Pbi::ItemRepository)
    @order_repository = T.let(ProductBacklogItemOrderRepository::AR, Pbi::OrderRepository)
  end

  sig {params(product_id: Product::Id, content: Pbi::Content).returns(Pbi::Id)}
  def perform(product_id, content)
    pbi = Pbi::Item.create(product_id, content)

    transaction do
      order = find_order(product_id)
      sleep 15
      order.append(pbi)
      @pbi_repository.add(pbi)
      @order_repository.update(order)
    end

    pbi.id
  end

  private

  sig {params(product_id: Product::Id).returns(Pbi::Order)}
  def find_order(product_id)
    order = @order_repository.find_by_product_id(product_id)
    return Pbi::Order.create(product_id) unless order

    order
  end
end
