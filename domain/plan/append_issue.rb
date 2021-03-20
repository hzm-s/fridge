# typed: strict
require 'sorbet-runtime'

module Plan
  class AppendIssue
    extend T::Sig

    sig {params(issue_repository: Issue::IssueRepository, plan_repository: PlanRepository).void}
    def initialize(issue_repository, plan_repository)
      @issue_repository = issue_repository
      @plan_repository = plan_repository
    end

    sig {params(product_id: Product::Id, issue: Issue::Issue).returns(Issue::Issue)}
    def append(product_id, issue)
      plan = @plan_repository.find_by_product_id(product_id)
      plan.recent_release.tap do |r|
        r.plan_issue(issue.id)
        plan.update_release(r)
      end

      @issue_repository.store(issue)
      @plan_repository.store(plan)

      issue
    end
  end
end
