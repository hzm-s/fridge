# typed: true
require 'sorbet-runtime'

module ProductBacklogQuery
  class Item < SimpleDelegator
    def status
      @__status ||= Pbi::Statuses.from_string(super)
    end
  end

  class Release < SimpleDelegator
    def initialize(release, all)
      super(release)
      @all = all
    end

    def items
      @__items ||= super.map { |id| @all.find { |item| item.id == id.to_s } }
    end
  end

  class Plan < SimpleDelegator
    def initialize(releases, plan = nil)
      super(releases)
      @plan = plan
    end

    def can_remove_release?
      return false unless @plan
      @plan.can_remove_release?
    end
  end

  class << self
    def call(product_id)
      plan = fetch_plan(product_id)
      return Plan.new([], nil) unless plan

      all = fetch_items(product_id)
      releases = plan.releases.map { |r| Release.new(r, all) }

      Plan.new(releases, plan)
    end

    private

    def fetch_plan(product_id)
      PlanRepository::AR.find_by_product_id(Product::Id.from_string(product_id))
    end

    def fetch_items(product_id)
      Dao::ProductBacklogItem
        .eager_load(:criteria)
        .where(dao_product_id: product_id)
        .map { |r| Item.new(r) }
    end
  end
end
