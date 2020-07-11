module ProductBacklogItemListQuery
  class << self
    def call(product_id)
      order = Dao::ProductBacklogOrder.find_by!(dao_product_id: product_id)
      items = Dao::ProductBacklogItem.where(dao_product_id: product_id).to_a

      order.product_backlog_item_ids.map do |pbi_id|
        items.find { |item| item.id == pbi_id }
      end
    end
  end
end
