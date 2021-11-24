# typed: strict
require 'sorbet-runtime'

module Work
  class Work
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(pbi: Pbi::Pbi).returns(T.attached_class)}
      def create(pbi)
        new(
          pbi.id,
          Statuses.initial(pbi.acceptance_criteria),
          Acceptance.new(pbi.acceptance_criteria, [].to_set),
          TaskList.new,
        )
      end

      sig {params(pbi_id: pbi::Id, status: Status, acceptance: Acceptance, tasks: TaskList).returns(T.attached_class)}
      def from_repository(pbi_id, status, acceptance, tasks)
        new(pbi_id, status, acceptance, tasks)
      end
    end

    sig {returns(Pbi::Id)}
    attr_reader :pbi_id

    sig {returns(Status)}
    attr_reader :status

    sig {returns(Acceptance)}
    attr_reader :acceptance

    sig {returns(TaskList)}
    attr_reader :tasks

    sig {params(pbi_id: Pbi::Id, status: Status, acceptance: Acceptance, tasks: TaskList).void}
    def initialize(pbi_id, status, acceptance, tasks)
      @pbi_id = pbi_id
      @status = status
      @acceptance = acceptance
      @tasks = tasks
    end

    sig {params(tasks: TaskList).void}
    def update_tasks(tasks)
      @tasks = tasks
    end

    sig {params(acceptance: Acceptance).void}
    def update_acceptance(acceptance)
      @acceptance = acceptance
      @status = @status.update_by_acceptance(@acceptance)
    end

    sig {void}
    def accept
      @status = @status.accept
    end
  end
end
