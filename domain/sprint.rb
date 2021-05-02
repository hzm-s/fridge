# typed: strict
module Sprint
  class AlreadyStarted < StandardError; end
  class AlreadyFinished < StandardError; end

  autoload :Id, 'sprint/id'
  autoload :Sprint, 'sprint/sprint'
  autoload :SprintRepository, 'sprint/sprint_repository'
end
