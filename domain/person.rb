# typed: strict
module Person
  class EmailNotUnique < StandardError; end

  autoload :Id, 'person/id'
  autoload :Person, 'person/person'
end
