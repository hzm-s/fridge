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

    sig {params(plan: Plan, release: Release, issue: Issue::Issue).returns(Issue::Issue)}
    def append(plan, release, issue)
      release.plan_issue(issue.id)
      plan.update_release(release)

      @issue_repository.store(issue)
      @plan_repository.store(plan)

      issue
    end
  end
end
