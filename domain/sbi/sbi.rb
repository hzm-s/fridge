# typed: strict
require 'sorbet-runtime'

module Sbi
  class Sbi
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(pbi_id: Pbi::Id).returns(T.attached_class)}
      def plan(pbi_id)
        new(pbi_id, TaskList.new)
      end

      sig {params(pbi_id: Pbi::Id, tasks: TaskList).returns(T.attached_class)}
      def from_repository(pbi_id, tasks)
        new(pbi_id, tasks)
      end
    end

    sig {returns(Pbi::Id)}
    attr_reader :pbi_id

    sig {returns(TaskList)}
    attr_reader :tasks

    sig {params(pbi_id: Pbi::Id, tasks: TaskList).void}
    def initialize(pbi_id, tasks)
      @pbi_id = pbi_id
      @tasks = tasks
    end

    sig {params(tasks: TaskList).void}
    def update_tasks(tasks)
      @tasks = tasks
    end
  end
end
