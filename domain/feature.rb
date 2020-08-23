# typed: strict
module Feature
  class InvalidDescription < ArgumentError; end
  class InvalidAcceptanceCriterion < ArgumentError; end

  class AssignProductBacklogItemNotAllowed < StandardError; end
  class ProductBacklogItemIsNotAssigned < StandardError; end
  class ItemCanNotRemove < StandardError; end

  autoload :Id, 'feature/id'
  autoload :Feature, 'feature/feature'
  autoload :Description, 'feature/description'
  autoload :AcceptanceCriterion, 'feature/acceptance_criterion'
  autoload :AcceptanceCriteria, 'feature/acceptance_criteria'
  autoload :StoryPoint, 'feature/story_point'
  autoload :Status, 'feature/status'
  autoload :Statuses, 'feature/statuses'
  autoload :FeatureRepository, 'feature/feature_repository'
end
