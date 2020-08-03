# typed: true
module ProductBacklogItemListQuery
  class Item < SimpleDelegator
    def status
      Pbi::Statuses.from_string(super)
    end
  end

  class << self
    def call(product_id, status: nil)
      order = fetch_order(product_id)
      return [] unless order

      items = fetch_items(product_id, status: status)

      ordered_items(order, items)
    end

    private

    def fetch_order(product_id)
      Dao::ProductBacklog.find_by(dao_product_id: product_id)
    end

    def fetch_items(product_id, status: nil)
      rel = Dao::ProductBacklogItem.eager_load(:criteria).where(dao_product_id: product_id)
      rel = rel.where(status: status) if status
      rel.map { |r| Item.new(r) }
    end

    def ordered_items(order, items)
      ordered =
        order.product_backlog_item_ids.map do |pbi_id|
          items.find { |item| item.id == pbi_id }
        end
      ordered.compact
    end
  end
end
