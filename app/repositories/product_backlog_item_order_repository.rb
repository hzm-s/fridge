# typed: strict
require 'sorbet-runtime'

module ProductBacklogItemOrderRepository
  module AR
    class << self
      extend T::Sig
      include Product::BacklogItemOrderRepository

      sig {override.params(product_id: Product::ProductId).returns(T.nilable(Product::BacklogItemOrder))}
      def find_by_product_id(product_id)
        r = Dao::ProductBacklogItemPriority.where(dao_product_id: product_id.to_s).order(:position)
        return nil if r.empty?

        Product::BacklogItemOrder.from_repository(
          product_id,
          r.pluck(:dao_product_backlog_item_id).map { |id| Product::BacklogItemId.from_repository(id) }
        )
      end

      sig {override.params(order: Product::BacklogItemOrder).void}
      def update(order)
        product_id = order.product_id.to_s

        Dao::ProductBacklogItemPriority.transaction do
          Dao::ProductBacklogItemPriority.where(dao_product_id: product_id).delete_all

          order.to_a.each_with_index do |product_backlog_item_id, position|
            Dao::ProductBacklogItemPriority.create!(
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
