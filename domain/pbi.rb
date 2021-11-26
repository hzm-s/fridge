# typed: strict
module Pbi
  class NotFound < StandardError; end
  class InvalidType < ArgumentError; end

  autoload :Pbi, 'pbi/pbi'
  autoload :Id, 'pbi/id'
  autoload :Types, 'pbi/types'
  autoload :Statuses, 'pbi/statuses'
  autoload :StoryPoint, 'pbi/story_point'
  autoload :AcceptanceCriteria, 'pbi/acceptance_criteria'
  autoload :PbiRepository, 'pbi/pbi_repository'
end
