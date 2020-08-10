# typed: strict
require 'sorbet-runtime'

class SortProductBacklogUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(product_id: Product::Id, pbi_id: Pbi::Id, to: Integer).void}
  def perform(product_id, pbi_id, to)
    plan = @repository.find_by_product_id(product_id)
    raise unless plan

    plan.move_item(pbi_id, 1, to)
    @repository.update(plan)
  end
end
