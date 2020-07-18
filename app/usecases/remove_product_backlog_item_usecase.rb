# typed: strict
require 'sorbet-runtime'

class RemoveProductBacklogItemUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @pbi_repository = T.let(ProductBacklogItemRepository::AR, Pbi::ItemRepository)
    @order_repository = T.let(ProductBacklogOrderRepository::AR, Pbi::OrderRepository)
  end

  sig {params(pbi_id: Pbi::Id).void}
  def perform(pbi_id)
    pbi = @pbi_repository.find_by_id(pbi_id)

    order = @order_repository.find_by_product_id(pbi.product_id)
    return unless order

    order.delete(pbi.id)

    transaction do
      @pbi_repository.delete(pbi_id)
      @order_repository.update(order)
    end
  end
end
