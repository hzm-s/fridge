# typed: true
require 'sorbet-runtime'

module ProductBacklogQuery
  class << self
    def call(product_id)
      items = fetch_pbis(product_id).map { |r| Item.new(r) }
      plan = fetch_plan(product_id)
      releases = plan.releases.map.with_index(1) { |r, i| Release.new(i, r, items) }
      ProductBacklog.new(plan: plan, releases: releases)
    end

    private

    def fetch_pbis(product_id)
      Dao::Pbi.eager_load(:criteria).where(dao_product_id: product_id)
    end

    def fetch_plan(product_id)
      Product::Id.from_string(product_id)
        .yield_self { |id| PlanRepository::AR.find_by_product_id(id) }
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
      @__status ||= Pbi::Statuses.from_string(__getobj__.status)
    end
  end

  class ProductBacklog < T::Struct
    prop :plan, Plan::Plan
    prop :releases, T::Array[ProductBacklogQuery::Release]

    def can_remove_release?
      plan.can_remove_release?
    end
  end
end
