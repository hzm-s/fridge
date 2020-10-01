# typed: strict
require 'sorbet-runtime'

module OrderRepository
  class AR
    class << self
      extend T::Sig
      include Order::OrderRepository

      sig {override.params(order: Order::Order).void}
      def store(order)
        dao = Dao::Order.new(dao_product_id: order.product_id.to_s)
        dao.entries = order.issues.to_a.map(&:to_s)
        dao.save!
      end
    end
  end
end
