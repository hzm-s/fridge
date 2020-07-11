module ProductBacklogItemListQuery
  class << self
    def call(product_id)
      Dao::ProductBacklogItem.where(dao_product_id: product_id)
    end
  end
end
