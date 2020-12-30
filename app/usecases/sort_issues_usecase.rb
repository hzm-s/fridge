# typed: strict
require 'sorbet-runtime'

class SortIssuesUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(product_id: Product::Id, issue_id: Issue::Id, to_index: Integer).void}
  def perform(product_id, issue_id, to_index)
    plan = @repository.find_by_product_id(product_id)

    target_issue_id = T.must(PlannedIssueResolver.resolve_pending(plan, to_index))
    new_pending = plan.pending.swap(issue_id, target_issue_id)

    plan.update_pending(new_pending)
    @repository.store(plan)
  end
end
