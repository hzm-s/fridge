module ProductBacklogItemQuery
  class << self
    def call(id)
      Dao::ProductBacklogItem.find(id)
    end
  end
end
