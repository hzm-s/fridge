# typed: strict
require 'sorbet-runtime'

class ChangeIssuePriorityUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(product_id: Product::Id, roles: Team::RoleSet, issue_id: Issue::Id, to_index: Integer).void}
  def perform(product_id, roles, issue_id, to_index)
    plan = @repository.find_by_product_id(product_id)

    release = plan.release_by_issue(issue_id)
    opposite = T.must(PlannedIssueQuery.call(plan, release.number, to_index))
    release.sort_issue_priority(issue_id, opposite)
    plan.update_release(roles, release)

    @repository.store(plan)
  end
end
