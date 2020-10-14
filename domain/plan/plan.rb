# typed: strict
require 'sorbet-runtime'

module Plan
  class Plan
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(product_id: Product::Id).returns(T.attached_class)}
      def create(product_id)
        new(product_id, Order.new([]))
      end

      sig {params(product_id: Product::Id, order: Order).returns(T.attached_class)}
      def from_repository(product_id, order)
        new(product_id, order)
      end
    end

    sig {returns(Product::Id)}
    attr_reader :product_id

    sig {returns(Order)}
    attr_reader :order

    sig {params(product_id: Product::Id, order: Order).void}
    def initialize(product_id, order)
      @product_id = product_id
      @order = order
    end

    sig {params(order: Order).void}
    def specify_order(order)
      @order = order
    end
  end
end
