# typed: strict
require 'sorbet-runtime'

module Issue
  class AcceptanceCriteria
    extend T::Sig

    class << self
      def create
        new([])
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

    sig {returns(T::Array[String])}
    def to_a
      @criteria.map(&:to_s)
    end

    sig {params(other: AcceptanceCriteria).returns(T::Boolean)}
    def ==(other)
      self.to_a == other.to_a
    end

    private

    def next_number
      return 1 if @criteria.empty?

      @criteria.last.number + 1
    end
  end
end
