# typed: strict
require 'sorbet-runtime'

module Issue
  class AcceptanceCriteria
    extend T::Sig

    class << self
      extend T::Sig

      sig {returns(T.attached_class)}
      def create
        new([])
      end

      sig {params(criteria: T::Array[AcceptanceCriterion]).returns(T.attached_class)}
      def from_repository(criteria)
        new(criteria)
      end
    end

    sig {params(criteria: T::Array[AcceptanceCriterion]).void}
    def initialize(criteria)
      @criteria = criteria
    end
    private_class_method :new

    sig {params(content: String).void}
    def append(content)
      @criteria << AcceptanceCriterion.new(next_number, content)
    end

    sig {params(criterion: AcceptanceCriterion).void}
    def update(criterion)
      remove(criterion.number)
      @criteria << AcceptanceCriterion.new(criterion.number, criterion.content)
    end

    sig {params(number: Integer).void}
    def remove(number)
      @criteria.reject! { |c| c.number == number }
    end

    sig {params(number: Integer).returns(T.nilable(AcceptanceCriterion))}
    def of(number)
      @criteria.find { |c| c.number == number }.dup
    end

    sig {returns(T::Boolean)}
    def empty?
      @criteria.empty?
    end

    sig {returns(Integer)}
    def size
      @criteria.size
    end

    sig {returns(T::Array[AcceptanceCriterion])}
    def to_a
      @criteria.sort_by(&:number).dup
    end

    sig {params(other: AcceptanceCriteria).returns(T::Boolean)}
    def ==(other)
      self.to_a == other.to_a
    end

    private

    sig {returns(Integer)}
    def next_number
      return 1 if @criteria.empty?

      T.must(@criteria.last).number + 1
    end
  end
end
