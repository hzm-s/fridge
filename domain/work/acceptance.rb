# typed: strict
require 'sorbet-runtime'

module Work
  class Acceptance
    extend T::Sig

    sig {returns(T::Set[Integer])}
    attr_reader :satisfied_criteria

    sig {params(criteria: Pbi::AcceptanceCriteria, satisfied_criteria: T::Set[Integer]).void}
    def initialize(criteria, satisfied_criteria)
      @criteria = criteria
      @satisfied_criteria = satisfied_criteria
    end

    sig {params(criterion_number: Integer).returns(T.self_type)}
    def satisfy(criterion_number)
      ensure_criterion_included!(criterion_number)
      raise AlreadySatisfied if satisfied?(criterion_number)

      self.class.new(@criteria, @satisfied_criteria + [criterion_number])
    end

    sig {params(criterion_number: Integer).returns(T.self_type)}
    def dissatisfy(criterion_number)
      ensure_criterion_included!(criterion_number)
      raise NotSatisfied unless satisfied?(criterion_number)

      self.class.new(@criteria, @satisfied_criteria - [criterion_number])
    end

    sig {params(criterion_number: Integer).returns(T::Boolean)}
    def satisfied?(criterion_number)
      @satisfied_criteria.include?(criterion_number)
    end

    sig {returns(T::Boolean)}
    def all_satisfied?
      @criteria.to_a_with_number.all? { |number, _| satisfied?(number) }
    end

    sig {params(other: Acceptance).returns(T::Boolean)}
    def ==(other)
      self.criteria == other.criteria &&
        self.satisfied_criteria == other.satisfied_criteria
    end

    protected

    sig {returns(Pbi::AcceptanceCriteria)}
    attr_reader :criteria

    private

    sig {params(criterion_number: Integer).void}
    def ensure_criterion_included!(criterion_number)
      raise AcceptanceCriterionNotFound unless @criteria.include?(criterion_number)
    end
  end
end
