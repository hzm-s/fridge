# typed: false

module ProductBacklogQuery
  class << self
    def call(product_id)
      items = fetch_issues(product_id).map { |i| IssueStruct.new(i) }
      order = fetch_order(product_id)
      ordered_items = order.entries.map { |e| items.find { |i| i.id == e } }

      ProductBacklog.new(items: ordered_items)
    end

    private

    def fetch_issues(product_id)
      Dao::Issue.eager_load(:criteria).where(dao_product_id: product_id)
    end

    def fetch_order(product_id)
      Dao::Order.find_by(dao_product_id: product_id)
    end
  end

  class ProductBacklog < T::Struct
    prop :items, T::Array[::IssueStruct]
  end
end
