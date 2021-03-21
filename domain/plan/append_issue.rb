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

    sig {params(product_id: Product::Id, issue: Issue::Issue, release_number: T.nilable(Integer)).returns(Issue::Issue)}
    def append(product_id, issue, release_number = nil)
      plan = @plan_repository.find_by_product_id(product_id)

      detect_release(plan, release_number).tap do |r|
        r.plan_issue(issue.id)
        plan.update_release(r)
      end

      @issue_repository.store(issue)
      @plan_repository.store(plan)

      issue
    end

    private

    sig {params(plan: Plan, release_number: T.nilable(Integer)).returns(Release)}
    def detect_release(plan, release_number = nil)
      return plan.recent_release unless release_number

      plan.release_of(release_number)
    end
  end
end
