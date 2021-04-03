# typed: strict
require 'sorbet-runtime'

class RescheduleIssueUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(product_id: Product::Id, roles: Team::RoleSet, issue_id: Issue::Id, release_number: Integer, to_index: Integer).void}
  def perform(product_id, roles, issue_id, release_number, to_index)
    plan = @repository.find_by_product_id(product_id)

    from = plan.release_by_issue(issue_id)
    to = plan.release_of(release_number)

    from.drop_issue(issue_id)
    plan.update_release(roles, from)

    to.plan_issue(issue_id)
    if opposite = PlannedIssueQuery.call(plan, release_number, to_index)
      to.sort_issue_priority(issue_id, opposite)
    end
    plan.update_release(roles, to)

    @repository.store(plan)
  end
end
