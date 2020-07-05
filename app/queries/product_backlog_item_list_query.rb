module ProductBacklogItemListQuery
  class << self
    def call(product_id)
      Dao::ProductBacklogItem
        .joins(:priority)
        .where(dao_product_backlog_item_priorities: { dao_product_id: product_id })
    end
  end
end
