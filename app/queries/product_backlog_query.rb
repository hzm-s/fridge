# typed: false
require 'sorbet-runtime'

module ProductBacklogQuery
  class << self
    def call(product_id)
      items = fetch_issues(product_id).map { |r| Item.new(r) }
      #plan = fetch_plan(product_id)
      #releases = plan.releases.map.with_index(1) { |r, i| Release.new(i, r, items) }
      ProductBacklog.new(items)
    end

    private

    def fetch_issues(product_id)
      Dao::Issue.eager_load(:criteria).where(dao_product_id: product_id).order(:created_at)
    end

    def fetch_plan(product_id)
      Product::Id.from_string(product_id)
        .yield_self { |id| PlanRepository::AR.find_by_product_id(id) }
    end
  end

  class ItemList < SimpleDelegator
    def items
      __getobj__
    end
  end

  class ProductBacklog < T::Struct
    prop :items, ItemList

    def initialize(items)
      super(items: ItemList.new(items))
    end

    def icebox
      items
    end

    def empty?
      items.empty?
    end
  end

  class Release < SimpleDelegator
    attr_reader :no

    def initialize(no, release, all_items)
      super(release)
      @no = no
      @all_items = all_items
    end

    def items
      @__items = __getobj__.items.map do |release_item|
        @all_items.find { |i| i.id == release_item.to_s }
      end
    end
  end

  class Item < SimpleDelegator
    def status
      @__status ||= Issue::Statuses.from_string(__getobj__.status)
    end
  end
end
