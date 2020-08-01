# typed: strict
require 'sorbet-runtime'

module Pbi
  class AcceptanceCriteria
    extend T::Sig

    sig {params(criteria: T::Array[AcceptanceCriterion]).void}
    def initialize(criteria)
      @criteria = criteria
    end

    sig {params(criterion: AcceptanceCriterion).returns(AcceptanceCriteria)}
    def append(criterion)
      self.class.new(@criteria + [criterion])
    end

    sig {params(criterion: AcceptanceCriterion).returns(AcceptanceCriteria)}
    def remove(criterion)
      self.class.new(@criteria.reject { |c| c == criterion })
    end

    sig {returns(T::Boolean)}
    def empty?
      @criteria.empty?
    end

    sig {returns(Integer)}
    def size
      @criteria.size
    end

    sig {returns(T::Array[String])}
    def to_a
      @criteria.map(&:to_s)
    end

    sig {params(other: AcceptanceCriteria).returns(T::Boolean)}
    def ==(other)
      self.to_a == other.to_a
    end
  end
end
