# typed: strict
module Release
  class ReleaseIsNotEmpty < StandardError; end
  class NeedAtLeastOneRelease < StandardError; end
  class DuplicatedIssue < StandardError; end
  class PermissionDenied < StandardError; end

  autoload :Release, 'release/release'
  autoload :ReleaseRepository, 'release/release_repository'
  autoload :IssueList, 'release/issue_list'
end
