# typed: strict
module Issue
  class InvalidDescription < ArgumentError; end
  class InvalidAcceptanceCriterion < ArgumentError; end

  class CanNotStartDevelopment < StandardError; end
  class NotDevelopmentStarted < StandardError; end
  class CanNotRemove < StandardError; end

  autoload :Id, 'issue/id'
  autoload :Pbi, 'issue/pbi'
  autoload :Description, 'issue/description'
  autoload :AcceptanceCriterion, 'issue/acceptance_criterion'
  autoload :AcceptanceCriteria, 'issue/acceptance_criteria'
  autoload :StoryPoint, 'issue/story_point'
  autoload :Status, 'issue/status'
  autoload :Statuses, 'issue/statuses'
  autoload :PbiRepository, 'issue/pbi_repository'
end
