# typed: strict
require 'sorbet-runtime'

module Work
  class TaskList
    extend T::Sig

    sig {params(tasks: T::Array[Task]).void}
    def initialize(tasks = [])
      @tasks = tasks
    end

    sig {returns(T::Boolean)}
    def empty?
      @tasks.empty?
    end
  end
end
