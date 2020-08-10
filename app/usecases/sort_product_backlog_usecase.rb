# typed: strict
require 'sorbet-runtime'

class SortProductBacklogUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(product_id: Product::Id, item_id: Pbi::Id, position: Integer).void}
  def perform(product_id, item_id, position)
    plan = @repository.find_by_product_id(product_id)
    raise unless plan

    plan.move_item(item_id, 1, position)
    @repository.update(plan)
  end
end
