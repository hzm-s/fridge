# typed: true

require 'sorbet-runtime'
require 'securerandom'

module Product
  class ProductId
    extend T::Sig

    class << self
      extend T::Sig

      sig {returns(ProductId)}
      def generate
        new(SecureRandom.uuid)
      end

      sig {params(str: String).returns(ProductId)}
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
      id
    end

    sig {params(other: ProductId).returns(T::Boolean)}
    def ==(other)
      self.id == other.id
    end

    protected

    sig {returns(String)}
    attr_reader :id
  end
end
