# typed: strict
require 'sorbet-runtime'

module Issue
  class AcceptanceCriteria
    extend T::Sig

    sig {params(criteria: T::Array[Shared::ShortSentence]).void}
    def initialize(criteria = [])
      @criteria = criteria
    end

    sig {params(content: Shared::ShortSentence).returns(T.self_type)}
    def append(content)
      self.class.new(@criteria + [content])
    end

    sig {params(number: Integer).returns(T.self_type)}
    def remove(number)
      self.class.new(@criteria.reject.with_index(1) { |_c, n| n == number })
    end

    sig {params(number: Integer, content: Shared::ShortSentence).returns(T.self_type)}
    def modify(number, content)
      new_contents =
        @criteria.map.with_index(1) do |c, n|
          n == number ? content : c
        end
      self.class.new(new_contents)
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
