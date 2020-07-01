# typed: strict
require 'sorbet-runtime'

module ProductBacklogItemOrderRepository
  module AR
    class << self
      extend T::Sig
      include Pbi::OrderRepository

      DAO = Dao::ProductBacklogItemPriority

      sig {override.params(product_id: Product::ProductId).returns(T.nilable(Pbi::Order))}
      def find_by_product_id(product_id)
        r = DAO.where(dao_product_id: product_id.to_s).order(:position)
        return nil if r.empty?

        Pbi::Order.from_repository(
          product_id,
          r.pluck(:dao_product_backlog_item_id).map { |id| Pbi::ItemId.from_repository(id) }
        )
      end

      sig {override.params(order: Pbi::Order).void}
      def update(order)
        product_id = order.product_id.to_s

        DAO.transaction do
          DAO.where(dao_product_id: product_id).delete_all

          order.to_a.each_with_index do |product_backlog_item_id, position|
            DAO.create!(
              dao_product_id: product_id,
              dao_product_backlog_item_id: product_backlog_item_id.to_s,
              position: position,
            )
          end
        end
      end
    end
  end
end
