# typed: strict
require 'sorbet-runtime'

class ChangeIssuePriorityUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(product_id: Product::Id, roles: Team::RoleSet, release_number: Integer, issue_id: Issue::Id, to_index: Integer).void}
  def perform(product_id, roles, release_number, issue_id, to_index)
    plan = @repository.find_by_product_id(product_id)

    opposite = T.must(PlannedIssueQuery.call(plan, release_number, to_index))

    plan.release_of(release_number).tap do |r|
      r.sort_issue_priority(issue_id, opposite)
      plan.update_release(r)
    end

    @repository.store(plan)
  end
end
