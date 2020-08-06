# typed: strict
module Pbi
  class InvalidContent < ArgumentError; end
  class AssignProductBacklogItemNotAllowed < StandardError; end
  class ProductBacklogItemIsNotAssigned < StandardError; end
  class ItemCanNotRemove < StandardError; end

  autoload :Order, 'pbi/order'

  autoload :Id, 'pbi/id'
  autoload :Item, 'pbi/item'
  autoload :Content, 'pbi/content'
  autoload :StoryPoint, 'pbi/story_point'
  autoload :AcceptanceCriterion, 'pbi/acceptance_criterion'
  autoload :AcceptanceCriteria, 'pbi/acceptance_criteria'

  autoload :Status, 'pbi/status'
  autoload :Statuses, 'pbi/statuses'
end
