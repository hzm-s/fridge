# typed: strict
module Work
  class InvalidTaskStatus < StandardError; end
  class InvalidTaskStatusUpdate < StandardError; end
  class InvalidStatus < StandardError; end
  class AcceptanceCriterionNotFound < StandardError; end
  class AlreadySatisfied < StandardError; end
  class NotSatisfied < StandardError; end

  autoload :Work, 'work/work'
  autoload :Task, 'work/task'
  autoload :TaskList, 'work/task_list'
  autoload :TaskStatus, 'work/task_status'
  autoload :WorkRepository, 'work/work_repository'
  autoload :Status, 'work/status' 
end
