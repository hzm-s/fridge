# typed: strict
require 'sorbet-runtime'

module Pbi
  class StoryPoint
    extend T::Sig

    AVAILABLE_VALUES = T.let([0, 1, 2, 3, 5, 8, 13], T::Array[Integer])

    class << self
      extend T::Sig

      sig {returns(T::Array[T.attached_class])}
      def all
        AVAILABLE_VALUES.map { |v| from_integer(v) } + [unknown]
      end

      sig {returns(T.attached_class)}
      def unknown
        new(nil)
      end

      sig {params(int: T.nilable(Integer)).returns(T.attached_class)}
      def from_integer(int)
        return unknown unless int

        raise ArgumentError unless AVAILABLE_VALUES.include?(int)

        new(int)
      end
      alias_method :from_repository, :from_integer
    end

    sig {params(value: T.nilable(Integer)).void}
    def initialize(value)
      @value = value
    end

    sig {returns(T.nilable(Integer))}
    def to_i
      @value
    end

    sig {returns(String)}
    def to_s
      return '?' unless to_i

      to_i.to_s
    end

    sig {params(other: StoryPoint).returns(T::Boolean)}
    def ==(other)
      self.to_i == other.to_i
    end
  end
end
