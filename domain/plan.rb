# typed: strict
module Plan
  class ReleaseIsNotEmpty < StandardError; end
  class NeedAtLeastOneRelease < StandardError; end
  class DuplicatedIssue < StandardError; end
  class PermissionDenied < StandardError; end
  class ReleaseNotFound < StandardError; end

  autoload :Plan, 'plan/plan'
  autoload :Release, 'plan/release'
  autoload :PlanRepository, 'plan/plan_repository'
  autoload :IssueList, 'plan/issue_list'
end
