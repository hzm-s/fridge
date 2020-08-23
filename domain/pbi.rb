# typed: strict
module Pbi
  class InvalidContent < ArgumentError; end

  autoload :Id, 'pbi/id'
  autoload :Item, 'pbi/item'
  autoload :Content, 'pbi/content'
  autoload :AcceptanceCriterion, 'pbi/acceptance_criterion'
  autoload :AcceptanceCriteria, 'pbi/acceptance_criteria'
end
