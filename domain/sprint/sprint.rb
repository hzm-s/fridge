# typed: strict
require 'sorbet-runtime'

module Sprint
  class Sprint
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(product_id: Product::Id, number: Integer).returns(T.attached_class)}
      def start(product_id, number)
        new(Id.create, product_id, number)
      end

      sig {params(id: Id, product_id: Product::Id, number: Integer).returns(T.attached_class)}
      def from_repository(id, product_id, number)
        new(id, product_id, number)
      end
    end

    sig {returns(Id)}
    attr_reader :id

    sig {returns(Product::Id)}
    attr_reader :product_id

    sig {returns(Integer)}
    attr_reader :number

    sig {params(id: Id, product_id: Product::Id, number: Integer).void}
    def initialize(id, product_id, number)
      @id = id
      @product_id = product_id
      @number = number
    end
  end
end
