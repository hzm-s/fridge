# typed: strict
require 'sorbet-runtime'
require 'securerandom'

module Shared
  class Identifier
    extend T::Sig

    class << self
      extend T::Sig

      sig {returns(T.attached_class)}
      def create
        new(SecureRandom.uuid)
      end

      sig {params(str: String).returns(T.attached_class)}
      def from_string(str)
        new(str)
      end
    end

    sig {params(id: String).void}
    def initialize(id)
      @id = id
    end
    private_class_method :new

    sig {returns(String)}
    def to_s
      @id
    end

    sig {params(other: Identifier).returns(T::Boolean)}
    def ==(other)
      self.instance_of?(other.class) &&
        self.to_s == other.to_s
    end

    sig {returns(String)}
    def inspect
      "#<#{self.class}:#{to_s.split('-').first}>"
    end
  end
end
