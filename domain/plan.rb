# typed: strict
module Plan
  class ReleaseIsNotEmpty < StandardError; end
  class DuplicatedIssue < StandardError; end
  class DuplicatedReleaseName < ArgumentError; end

  autoload :Plan, 'plan/plan'
  autoload :IssueList, 'plan/issue_list'
  autoload :Release, 'plan/release'
  autoload :ReleaseList, 'plan/release_list'
  autoload :PlanRepository, 'plan/plan_repository'
end
