# typed: false
require 'sorbet-runtime'

module ProductBacklogQuery
  class << self
    def call(product_id)
      items = fetch_pbis(product_id).map { |r| Item.new(r) }
      releases = fetch_releases(product_id).map.with_index(1) { |r, i| Release.new(i, r, items) }
      ProductBacklog.new(releases)
    end

    private

    def fetch_pbis(product_id)
      Dao::Pbi.eager_load(:criteria).where(dao_product_id: product_id)
    end

    def fetch_releases(product_id)
      Product::Id.from_string(product_id)
        .yield_self { |id| PlanRepository::AR.find_by_product_id(id) }
        .releases
    end
  end

  class ProductBacklog < Struct.new(:releases)
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
      @__status ||= Pbi::Statuses.from_string(__getobj__.status)
    end
  end
end
