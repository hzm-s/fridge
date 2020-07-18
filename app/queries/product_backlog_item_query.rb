# typed: true
module ProductBacklogItemQuery
  class << self
    def call(id)
      Dao::ProductBacklogItem.eager_load(:criteria).find(id)
    end
  end
end
