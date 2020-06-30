# typed: strong

require 'sorbet-runtime'
require 'securerandom'

module Product
  class BacklogItemId
    extend T::Sig

    class << self
      extend T::Sig

      sig {returns(BacklogItemId)}
      def generate
        new(SecureRandom.uuid)
      end

      sig {params(id: String).returns(BacklogItemId)}
      def from_repository(id)
        new(id)
      end
      alias_method :from_string, :from_repository
    end

    sig {params(id: String).void}
    def initialize(id)
      @id = id
    end
    private_class_method :new

    sig {returns(String)}
    def to_s
      id
    end

    sig {params(other: BacklogItemId).returns(T::Boolean)}
    def ==(other)
      self.id == other.id
    end

    protected

    sig {returns(String)}
    attr_reader :id
  end
end
