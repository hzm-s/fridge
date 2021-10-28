# typed: strict
require 'sorbet-runtime'

module Pbi
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
      to_a_with_number
        .reject { |n, _| n == number }
        .map { |_, c| c }
        .then { |removed| self.class.new(removed) }
    end

    sig {params(number: Integer, content: Shared::ShortSentence).returns(T.self_type)}
    def modify(number, content)
      to_a_with_number
        .map { |n, c| n == number ? content : c }
        .then { |modified| self.class.new(modified) }
    end

    sig {returns(T::Boolean)}
    def empty?
      @criteria.empty?
    end

    sig {returns(Integer)}
    def size
      @criteria.size
    end

    sig {params(number: Integer).returns(T::Boolean)}
    def include?(number)
      !!@criteria.at(number - 1)
    end

    sig {returns(T::Array[String])}
    def to_a
      @criteria.map(&:to_s).deep_dup
    end

    sig {returns(T::Array[[Integer, String]])}
    def to_a_with_number
      to_a.map.with_index(1) { |c, n| [n, c] }
    end

    sig {params(other: AcceptanceCriteria).returns(T::Boolean)}
    def ==(other)
      self.to_a == other.to_a
    end
  end
end
