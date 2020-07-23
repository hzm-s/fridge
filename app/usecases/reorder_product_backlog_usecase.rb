# typed: strict
require 'sorbet-runtime'

class ReorderProductBacklogUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(ProductBacklogOrderRepository::AR, Pbi::OrderRepository)
  end

  sig {params(product_id: Product::Id, pbi_id: Pbi::Id, to: Integer).void}
  def perform(product_id, pbi_id, to)
    order = @repository.find_by_product_id(product_id)
    raise unless order

    order.move_item_to(pbi_id, to)
    @repository.update(order)
  end
end
