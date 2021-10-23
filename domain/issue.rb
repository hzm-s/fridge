# typed: strict
module Issue
  class NotFound < StandardError; end
  class InvalidType < ArgumentError; end
  class CanNotPrepare < StandardError; end
  class CanNotEstimate < StandardError; end
  class CanNotAssignToSprint < StandardError; end
  class CanNotRevertFromSprint < StandardError; end
  class CanNotAccept < StandardError; end

  autoload :Id, 'issue/id'
  autoload :Issue, 'issue/issue'
  autoload :Types, 'issue/types'
  autoload :AcceptanceCriteria, 'issue/acceptance_criteria'
  autoload :StoryPoint, 'issue/story_point'
  autoload :Statuses, 'issue/statuses'
  autoload :List, 'issue/list'
  autoload :IssueRepository, 'issue/issue_repository'
end
