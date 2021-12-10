# typed: strict
require 'sorbet-runtime'

module Sbi
  class NotFound < StandardError; end
  class InvalidTaskStatus < StandardError; end
  class InvalidTaskStatusUpdate < StandardError; end

  autoload :Id, 'sbi/id'
  autoload :Sbi, 'sbi/sbi'
  autoload :SbiRepository, 'sbi/sbi_repository'
  autoload :Task, 'sbi/task'
  autoload :TaskList, 'sbi/task_list'
  autoload :TaskStatus, 'sbi/task_status'
end
