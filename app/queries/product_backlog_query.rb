# typed: true
require 'sorbet-runtime'

module ProductBacklogQuery
  class Item < SimpleDelegator
    def status
      @__status ||= Feature::Statuses.from_string(super)
    end
  end

  class Release
    def initialize(pbl, all)
      @pbl = pbl
      @all = all
    end

    def items
      @__items ||= @pbl.items.map { |item| @all.find { |f| f.id == item.to_s } }
    end
  end

  class << self
    def call(product_id)
      pbl = fetch_product_backlog(product_id)
      return [] unless pbl

      features = fetch_features(product_id)
      [Release.new(pbl, features)]
    end

    private

    def fetch_product_backlog(product_id)
      ProductBacklogRepository::AR.find_by_product_id(Product::Id.from_string(product_id))
    end

    def fetch_features(product_id)
      Dao::Feature
        .eager_load(:criteria)
        .where(dao_product_id: product_id)
        .map { |r| Item.new(r) }
    end
  end
end
