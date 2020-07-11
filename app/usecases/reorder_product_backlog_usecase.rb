# typed: strict
require 'sorbet-runtime'

class ReorderProductBacklogUsecase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(ProductBacklogItemOrderRepository::AR, Pbi::OrderRepository)
  end

  sig {params(product_id: Product::ProductId, src: Pbi::ItemId, dst: Pbi::ItemId).void}
  def perform(product_id, src, dst)
    order = @repository.find_by_product_id(product_id)
    raise unless order

    order.move_item_to(src, dst)
    @repository.update(order)
  end
end
