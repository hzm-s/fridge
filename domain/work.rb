# typed: strict
module Work
  class InvalidTaskStatus < StandardError; end
  class InvalidTaskStatusUpdate < StandardError; end

  autoload :Work, 'work/work'
  autoload :Task, 'work/task'
  autoload :TaskList, 'work/task_list'
  autoload :TaskStatus, 'work/task_status'
  autoload :WorkRepository, 'work/work_repository'
end
