# typed: strict
require 'sorbet-runtime'

module Work
  class Acceptance
    extend T::Sig

    sig {returns(T::Set[Integer])}
    attr_reader :satisfied_criteria

    sig {params(issue_type: Issue::Type, criteria: Issue::AcceptanceCriteria, satisfied_criteria: T::Set[Integer]).void}
    def initialize(issue_type, criteria, satisfied_criteria)
      @issue_type = issue_type
      @criteria = criteria
      @satisfied_criteria = satisfied_criteria
    end

    sig {params(criterion_number: Integer).returns(T.self_type)}
    def satisfy(criterion_number)
      ensure_criterion_included!(criterion_number)
      raise AlreadySatisfied if @satisfied_criteria.include?(criterion_number)

      self.class.new(@issue_type, @criteria, @satisfied_criteria + [criterion_number])
    end

    sig {params(criterion_number: Integer).returns(T.self_type)}
    def dissatisfy(criterion_number)
      ensure_criterion_included!(criterion_number)
      raise NotSatisfied unless @satisfied_criteria.include?(criterion_number)

      self.class.new(@issue_type, @criteria, @satisfied_criteria - [criterion_number])
    end

    sig {returns(Status)}
    def status
      return Status::NotAccepted unless all_satisfied?

      Status::Acceptable
    end

    sig {returns(Activity::Set)}
    def avaiable_activities
      Activity::Set.new([@issue_type.acceptance_activity])
    end

    sig {params(other: Acceptance).returns(T::Boolean)}
    def ==(other)
      self.issue_type == other.issue_type &&
        self.criteria == other.criteria &&
        self.satisfied_criteria == other.satisfied_criteria
    end

    protected

    sig {returns(Issue::Type)}
    attr_reader :issue_type

    sig {returns(Issue::AcceptanceCriteria)}
    attr_reader :criteria

    private

    def all_satisfied?
      @satisfied_criteria.size == @criteria.size
    end

    sig {params(criterion_number: Integer).void}
    def ensure_criterion_included!(criterion_number)
      raise AcceptanceCriterionNotFound unless @criteria.include?(criterion_number)
    end
  end
end
