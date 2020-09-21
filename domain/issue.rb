# typed: strict
module Issue
  class InvalidDescription < ArgumentError; end
  class InvalidAcceptanceCriterion < ArgumentError; end

  autoload :Id, 'issue/id'
  autoload :Issue, 'issue/issue'
  autoload :Description, 'issue/description'
  autoload :AcceptanceCriterion, 'issue/acceptance_criterion'
  autoload :AcceptanceCriteria, 'issue/acceptance_criteria'
  autoload :StoryPoint, 'issue/story_point'
  autoload :Status, 'issue/status'
  autoload :Statuses, 'issue/statuses'
  autoload :IssueRepository, 'issue/issue_repository'
end
