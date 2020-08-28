# typed: strict
module Pbi
  class InvalidDescription < ArgumentError; end
  class InvalidAcceptanceCriterion < ArgumentError; end

  class CanNotStartDevelopment < StandardError; end
  class NotDevelopmentStarted < StandardError; end
  class CanNotRemove < StandardError; end

  autoload :Id, 'pbi/id'
  autoload :Pbi, 'pbi/pbi'
  autoload :Description, 'pbi/description'
  autoload :AcceptanceCriterion, 'pbi/acceptance_criterion'
  autoload :AcceptanceCriteria, 'pbi/acceptance_criteria'
  autoload :StoryPoint, 'pbi/story_point'
  autoload :Status, 'pbi/status'
  autoload :Statuses, 'pbi/statuses'
  autoload :PbiRepository, 'pbi/pbi_repository'
end
