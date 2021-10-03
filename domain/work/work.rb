# typed: strict
require 'sorbet-runtime'

module Work
  class Work
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(issue: Issue::Issue).returns(T.attached_class)}
      def create(issue)
        new(
          issue.id,
          Statuses.initial(issue.type, issue.acceptance_criteria),
          Acceptance.new(issue.type, issue.acceptance_criteria, [].to_set),
          TaskList.new,
        )
      end

      sig {params(issue_id: Issue::Id, acceptance: Acceptance, tasks: TaskList).returns(T.attached_class)}
      def from_repository(issue_id, acceptance, tasks)
        new(issue_id, acceptance, tasks)
      end
    end

    sig {returns(Issue::Id)}
    attr_reader :issue_id

    sig {returns(Status)}
    attr_reader :status

    sig {returns(Acceptance)}
    attr_reader :acceptance

    sig {returns(TaskList)}
    attr_reader :tasks

    sig {params(issue_id: Issue::Id, status: Status, acceptance: Acceptance, tasks: TaskList).void}
    def initialize(issue_id, status, acceptance, tasks)
      @issue_id = issue_id
      @status = status
      @acceptance = acceptance
      @tasks = tasks
    end

    sig {params(tasks: TaskList).void}
    def update_tasks(tasks)
      @tasks = tasks
    end

    #def update_acceptance(acceptance)
    #  @acceptance = acceptance
    #  @status = @status.update_by_acceptance(@acceptance)
    #end

    #def accept
    #  @status = @status.accept
    #end

    sig {params(criterion_number: Integer).void}
    def satisfy_acceptance_criterion(criterion_number)
      @acceptance = @acceptance.satisfy(criterion_number)
    end

    sig {params(criterion_number: Integer).void}
    def dissatisfy_acceptance_criterion(criterion_number)
      @acceptance = @acceptance.dissatisfy(criterion_number)
    end
  end
end
