# typed: strict
module Work
  class InvalidTaskStatus < StandardError; end

  autoload :Work, 'work/work'
  autoload :Task, 'work/task'
  autoload :TaskStatus, 'work/task_status'
  autoload :WorkRepository, 'work/work_repository'
end
