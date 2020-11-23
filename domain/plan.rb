# typed: strict
module Plan
  class ReleaseIsNotEmpty < StandardError; end
  class DuplicatedIssue < StandardError; end

  autoload :Plan, 'plan/plan'
  autoload :IssueContainer, 'plan/issue_container'
  autoload :IssueList, 'plan/issue_list'
  autoload :Release, 'plan/release'
  autoload :ReleaseList, 'plan/release_list'
  autoload :PlanRepository, 'plan/plan_repository'
end
