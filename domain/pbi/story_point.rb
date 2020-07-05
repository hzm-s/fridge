# typed: strict
require 'sorbet-runtime'

module Pbi
  class StoryPoint
    extend T::Sig

    class << self
      extend T::Sig

      sig {returns(T.attached_class)}
      def unknown
        new(nil)
      end

      sig {params(int: T.nilable(Integer)).returns(T.attached_class)}
      def from_integer(int)
        return unknown unless int

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

    sig {params(other: StoryPoint).returns(T::Boolean)}
    def ==(other)
      self.to_i == other.to_i
    end
  end
end
