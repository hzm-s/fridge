# typed: true
module ProductBacklogItemListQuery
  class << self
    def call(product_id)
      order = fetch_order(product_id)
      return [] unless order

      items = fetch_items(product_id)

      order.product_backlog_item_ids.map do |pbi_id|
        items.find { |item| item.id == pbi_id }
      end
    end

    private

    def fetch_order(product_id)
      Dao::ProductBacklogOrder.find_by(dao_product_id: product_id)
    end

    def fetch_items(product_id)
      Dao::ProductBacklogItem.eager_load(:criteria).where(dao_product_id: product_id).to_a
    end
  end
end
