# typed: true
module ProductBacklogItemQuery
  class Item < SimpleDelegator
    def status
      @__status ||= Pbi::Statuses.from_string(super)
    end
  end

  class << self
    def call(id)
      rel = Dao::ProductBacklogItem.eager_load(:criteria).find(id)
      Item.new(rel)
    end
  end
end
