# typed: strict
require 'sorbet-runtime'

module Work
  class Work
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(issue_id: Issue::Id, issue_type: Issue::Type, criteria: Issue::AcceptanceCriteria).returns(T.attached_class)}
      def create(issue_id, issue_type, criteria)
        new(
          issue_id,
          Acceptance.new(issue_type, criteria, [].to_set),
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

    sig {returns(Acceptance)}
    attr_reader :acceptance

    sig {returns(TaskList)}
    attr_reader :tasks

    sig {params(issue_id: Issue::Id, acceptance: Acceptance, tasks: TaskList).void}
    def initialize(issue_id, acceptance, tasks)
      @issue_id = issue_id
      @acceptance = acceptance
      @tasks = tasks
    end

    sig {params(tasks: TaskList).void}
    def update_tasks(tasks)
      @tasks = tasks
    end

    sig {params(criterion_number: Integer).void}
    def satisfy_acceptance_criterion(criterion_number)
      @acceptance = @acceptance.satisfy(criterion_number)
    end

    sig {params(criterion_number: Integer).void}
    def dissatisfy_acceptance_criterion(criterion_number)
    end
  end
end
