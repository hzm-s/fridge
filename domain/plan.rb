# typed: strict
module Plan
  class ReleaseIsNotEmpty < StandardError; end
  class NeedAtLeastOneRelease < StandardError; end
  class DuplicatedIssue < StandardError; end
  class PermissionDenied < StandardError; end

  autoload :Release, 'plan/release'
  autoload :ReleaseRepository, 'plan/release_repository'
  autoload :IssueList, 'plan/issue_list'
end
