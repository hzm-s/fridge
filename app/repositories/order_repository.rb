# typed: strict
require 'sorbet-runtime'

module OrderRepository
  class AR
    class << self
      extend T::Sig
      include Order::OrderRepository

      sig {override.params(product_id: Product::Id).returns(Order::Order)}
      def find_by_product_id(product_id)
        Dao::Order.find_by(dao_product_id: product_id.to_s).read
      end

      sig {override.params(order: Order::Order).void}
      def store(order)
        dao = Dao::Order.find_or_initialize_by(dao_product_id: order.product_id.to_s)
        dao.write(order)
        dao.save!
      end
    end
  end
end
