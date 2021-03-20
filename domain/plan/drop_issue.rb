# typed: strict
require 'sorbet-runtime'

module Plan
  class DropIssue
    extend T::Sig

    sig {params(issue_repository: Issue::IssueRepository, plan_repository: PlanRepository).void}
    def initialize(issue_repository, plan_repository)
      @issue_repository = issue_repository
      @plan_repository = plan_repository
    end

    sig {params(product_id: Product::Id, roles: Team::RoleSet, issue_id: Issue::Id).void}
    def drop(product_id, roles, issue_id)
      plan = @plan_repository.find_by_product_id(product_id)
      plan.release_by_issue(issue_id).tap do |r|
        r.drop_issue(issue_id)
        plan.update_release(r)
      end
      @plan_repository.store(plan)

      @issue_repository.remove(issue_id)
    end
  end
end
