# typed: strict
require 'sorbet-runtime'

module Work
  class NotFound < StandardError; end
  class InvalidTaskStatus < StandardError; end
  class InvalidTaskStatusUpdate < StandardError; end

  autoload :Work, 'work/work'
  autoload :WorkRepository, 'work/work_repository'
  autoload :Task, 'work/task'
  autoload :TaskList, 'work/task_list'
  autoload :TaskStatus, 'work/task_status'
end
