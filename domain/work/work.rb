# typed: strict
require 'sorbet-runtime'

module Work
  class Work
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(issue_id: Issue::Id).returns(T.attached_class)}
      def create(issue_id)
        new(issue_id, Status::NotAccepted, [].to_set, TaskList.new)
      end

      sig {params(
        issue_id: Issue::Id,
        status: Status,
        satisfied_acceptance_criteria: T::Set[Integer],
        tasks: TaskList,
      ).returns(T.attached_class)}
      def from_repository(issue_id, status, satisfied_acceptance_criteria, tasks)
        new(issue_id, status, satisfied_acceptance_criteria, tasks)
      end
    end

    sig {returns(Issue::Id)}
    attr_reader :issue_id

    sig {returns(Status)}
    attr_reader :status

    sig {returns(T::Set[Integer])}
    attr_reader :satisfied_acceptance_criteria

    sig {returns(TaskList)}
    attr_reader :tasks

    sig {params(
      issue_id: Issue::Id,
      status: Status,
      satisfied_acceptance_criteria: T::Set[Integer],
      tasks: TaskList,
    ).void}
    def initialize(issue_id, status, satisfied_acceptance_criteria, tasks)
      @issue_id = issue_id
      @status = status
      @satisfied_acceptance_criteria = satisfied_acceptance_criteria
      @tasks = tasks
    end

    sig {params(tasks: TaskList).void}
    def update_tasks(tasks)
      @tasks = tasks
    end

    sig {params(criteria: Issue::AcceptanceCriteria, number: Integer).void}
    def satisfy_acceptance_criterion(criteria, number)
      raise AcceptanceCriterionNotFound unless criteria.include?(number)
      raise AlreadySatisfied if @satisfied_acceptance_criteria.include?(number)

      @satisfied_acceptance_criteria << number
      @status = @status.update(@satisfied_acceptance_criteria, criteria)
    end

    sig {params(criteria: Issue::AcceptanceCriteria, number: Integer).void}
    def dissatisfy_acceptance_criterion(criteria, number)
      raise AcceptanceCriterionNotFound unless criteria.include?(number)
      raise NotSatisfied unless @satisfied_acceptance_criteria.include?(number)

      @satisfied_acceptance_criteria.delete(number)
      @status = @status.update(@satisfied_acceptance_criteria, criteria)
    end
  end
end
