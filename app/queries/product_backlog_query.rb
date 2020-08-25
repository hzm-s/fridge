# typed: false
require 'sorbet-runtime'

module ProductBacklogQuery
  class << self
    def call(product_id)
      ProductBacklog.new(
        ordered_item_ids: fetch_ordered_item_ids(product_id),
        releases: fetch_releases(product_id),
        features: fetch_features(product_id)
      )
    end

    private

    def fetch_ordered_item_ids(product_id)
      Dao::ProductBacklog.find_by(dao_product_id: product_id)&.items || []
    end

    def fetch_features(product_id)
      Dao::Feature
        .eager_load(:criteria)
        .where(dao_product_id: product_id)
        .map { |r| Item.new(r) }
    end

    def fetch_releases(product_id)
      ReleaseRepository::AR.all_by_product_id(Product::Id.from_string(product_id))
    end
  end

  class ProductBacklog

    def initialize(ordered_item_ids:, releases:, features:)
      @ordered_item_ids = ordered_item_ids
      @releases = releases
      @features = features
    end

    def items
      @__items ||= @ordered_item_ids.map { |o| @features.find { |f| f.id == o } }
    end

    def releases
      @__releases ||= @releases.map { |r| Release.new(r, items.select { |i| r.items.include?(i.id) }) }
    end
  end

  class Release < SimpleDelegator
    attr_reader :items
    
    def initialize(release, items)
      super(release)
      @items = items
    end
  end

  class Item < SimpleDelegator
    def status
      @__status ||= Feature::Statuses.from_string(super)
    end
  end
end
