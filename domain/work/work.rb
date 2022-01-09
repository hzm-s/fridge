# typed: strict
require 'sorbet-runtime'

module Work
  class Work
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(pbi_id: Pbi::Id).returns(T.attached_class)}
      def assign(pbi_id)
        new(pbi_id, Statuses::Assigned, TaskList.new)
      end

      sig {params(pbi_id: Pbi::Id, tasks: TaskList).returns(T.attached_class)}
      def from_repository(pbi_id, tasks)
        new(pbi_id, tasks)
      end
    end

    sig {returns(Pbi::Id)}
    attr_reader :pbi_id

    sig {returns(Statuses)}
    attr_reader :status

    sig {returns(TaskList)}
    attr_reader :tasks

    sig {params(pbi_id: Pbi::Id, status: Statuses, tasks: TaskList).void}
    def initialize(pbi_id, status, tasks)
      @pbi_id = pbi_id
      @status = status
      @tasks = tasks
    end

    sig {params(tasks: TaskList).void}
    def update_tasks(tasks)
      @tasks = tasks
    end
  end
end
