# typed: true
module ProductBacklogItemListQuery
  class Item < SimpleDelegator
    def status
      Pbi::Statuses.from_string(super)
    end
  end

  class << self
    def call(product_id)
      order = fetch_order(product_id)
      return [] unless order

      items = fetch_items(product_id)

      order.product_backlog_item_ids.map do |pbi_id|
        items.find { |item| item.id == pbi_id }
      end
    end

    private

    def fetch_order(product_id)
      Dao::ProductBacklog.find_by(dao_product_id: product_id)
    end

    def fetch_items(product_id)
      rel = Dao::ProductBacklogItem.eager_load(:criteria).where(dao_product_id: product_id)
      rel.map { |r| Item.new(r) }
    end
  end
end
