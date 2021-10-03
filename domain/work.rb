# typed: strict
module Work
  class InvalidTaskStatus < StandardError; end
  class InvalidTaskStatusUpdate < StandardError; end
  class AcceptanceCriterionNotFound < StandardError; end
  class AlreadySatisfied < StandardError; end
  class NotSatisfied < StandardError; end

  autoload :Work, 'work/work'
  autoload :Acceptance, 'work/acceptance'
  autoload :Task, 'work/task'
  autoload :TaskList, 'work/task_list'
  autoload :TaskStatus, 'work/task_status'
  autoload :WorkRepository, 'work/work_repository'
  autoload :Statuses, 'work/statuses' 
end
