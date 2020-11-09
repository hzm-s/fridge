# typed: false

module ProductBacklogQuery
  class << self
    def call(product_id)
      items = fetch_issues(product_id).map { |i| IssueStruct.new(i) }
      order = fetch_order(product_id)
      ordered_items = order.map { |e| items.find { |i| i.id == e } }

      ProductBacklog.new(unscoped: ordered_items)
    end

    private

    def fetch_issues(product_id)
      Dao::Issue.eager_load(:criteria).where(dao_product_id: product_id)
    end

    def fetch_order(product_id)
      Dao::Plan.find_by(dao_product_id: product_id).order
    end
  end

  class ProductBacklog < T::Struct
    prop :unscoped, T::Array[::IssueStruct]
  end
end
