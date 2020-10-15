# typed: strict
require 'sorbet-runtime'

class SwapOrderedIssuesUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(product_id: Product::Id, issue_id: Issue::Id, to_index: Integer).void}
  def perform(product_id, issue_id, to_index)
    plan = @repository.find_by_product_id(product_id)

    current_order = plan.order
    new_order = current_order.swap(issue_id, current_order.at(to_index))
    plan.specify_order(new_order)

    @repository.store(plan)
  end
end
