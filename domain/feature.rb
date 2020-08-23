# typed: strict
require 'sorbet-runtime'

module Feature
  extend T::Sig

  class AssignProductBacklogItemNotAllowed < StandardError; end
  class ProductBacklogItemIsNotAssigned < StandardError; end
  class ItemCanNotRemove < StandardError; end

  autoload :Id, 'feature/id'
  autoload :Feature, 'feature/feature'
  autoload :AcceptanceCriterion, 'feature/acceptance_criterion'
  autoload :StoryPoint, 'feature/story_point'
  autoload :Status, 'feature/status'
  autoload :Statuses, 'feature/statuses'

  AcceptanceCriteria = T.type_alias {T::Array[AcceptanceCriterion]}
end
