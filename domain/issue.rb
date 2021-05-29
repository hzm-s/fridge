# typed: strict
module Issue
  class InvalidType < ArgumentError; end
  class InvalidDescription < ArgumentError; end
  class InvalidAcceptanceCriterion < ArgumentError; end
  class CanNotEstimate < ArgumentError; end
  class CanNotAssignToSprint < StandardError; end
  class CanNotRevertFromSprint < StandardError; end
  class NotFound < StandardError; end

  autoload :Id, 'issue/id'
  autoload :Issue, 'issue/issue'
  autoload :Types, 'issue/types'
  autoload :Description, 'issue/description'
  autoload :AcceptanceCriterion, 'issue/acceptance_criterion'
  autoload :AcceptanceCriteria, 'issue/acceptance_criteria'
  autoload :StoryPoint, 'issue/story_point'
  autoload :Statuses, 'issue/statuses'
  autoload :List, 'issue/list'
  autoload :IssueRepository, 'issue/issue_repository'
end
