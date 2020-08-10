# typed: true
module ProductBacklogItemListQuery
  class Item < SimpleDelegator
    def status
      Pbi::Statuses.from_string(super)
    end
  end

  class << self
    def call(product_id, status: nil)
      plan = fetch_plan(product_id)
      return [] unless plan

      items = fetch_items(product_id, status: status)

      ordered_items(plan, items)
    end

    private

    def fetch_plan(product_id)
      Dao::Plan.find_by(dao_product_id: product_id)
    end

    def fetch_items(product_id, status: nil)
      rel = Dao::ProductBacklogItem.eager_load(:criteria).where(dao_product_id: product_id)
      rel = rel.where(status: status) if status
      rel.map { |r| Item.new(r) }
    end

    def ordered_items(plan, items)
      plan
        .releases
        .map { |r| r['items'] }
        .flatten
        .map { |id| items.find { |i| i.id == id } }
        .compact
    end
  end
end
