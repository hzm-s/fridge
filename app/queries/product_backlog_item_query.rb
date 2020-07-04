module ProductBacklogItemQuery
  class Dto < SimpleDelegator
    def product_id
      priority.dao_product_id
    end
  end

  class << self
    def call(id)
      pbi = Dao::ProductBacklogItem.includes(:priority).find(id)
      Dto.new(pbi)
    end
  end
end
