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

    issues = plan.pending
    plan.update_pending(issues.swap(issue_id, issues.at(to_index)))

    @repository.store(plan)
  end
end
