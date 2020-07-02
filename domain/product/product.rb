# typed: strict
require 'sorbet-runtime'

module Product
  class Product
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(name: String).returns(T.attached_class)}
      def create(name)
        new(
          ProductId.create,
          name
        )
      end

      sig {params(id: ProductId, name: String).returns(T.attached_class)}
      def from_repository(id, name)
        new(id, name)
      end
    end

    sig {returns(::Product::ProductId)}
    attr_reader :id

    sig {returns(String)}
    attr_reader :name

    sig {returns(T.nilable(String))}
    attr_reader :description

    sig {params(id: ProductId, name: String, description: T.nilable(String)).void}
    def initialize(id, name, description: nil)
      @id = id
      @name = name
      @description = description
    end
  end
end
