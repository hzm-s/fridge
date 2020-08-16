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

  class << self
    def call(product_id)
      releases = fetch_all(product_id)
      return releases if releases.empty?

      items = fetch_items(product_id)
      releases.map { |r| Release.new(r, items) }
    end

    private

    def fetch_all(product_id)
      ReleaseRepository::AR.all_by_product_id(Product::Id.from_string(product_id))
    end

    def fetch_items(product_id)
      Dao::ProductBacklogItem
        .eager_load(:criteria)
        .where(dao_product_id: product_id)
        .map { |r| Item.new(r) }
    end
  end
end
