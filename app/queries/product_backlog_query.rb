# typed: false
require 'sorbet-runtime'

module ProductBacklogQuery
  class << self
    def call(product_id)
      items = fetch_issues(product_id).map { |i| Item.new(i) }
      items_per_release = items.group_by(&:dao_release_id)

      icebox = ItemList.new(
        id: nil,
        title: 'Icebox',
        items: Array(items_per_release[nil]).sort_by(&:created_at)
      )

      releases = fetch_release(product_id).map do |r|
        ItemList.new(
          id: r.id,
          title: r.title,
          items: Array(items_per_release[r.id])
        )
      end

      ProductBacklog.new(icebox: icebox, releases: releases)
    end

    private

    def fetch_issues(product_id)
      Dao::Issue
        .eager_load(:criteria, :release_item)
        .where(dao_product_id: product_id)
        .order('dao_release_items.id, dao_issues.created_at')
    end

    def fetch_release(product_id)
      Dao::Release.where(dao_product_id: product_id).order(:created_at)
    end
  end

  class Item < SimpleDelegator
    def status
      @__status ||= Issue::Statuses.from_string(super)
    end

    def criteria
      @__criteria ||= super.sort_by(&:id)
    end
  end

  class ItemList < T::Struct
    prop :id, T.nilable(String)
    prop :title, T.nilable(String)
    prop :items, T::Array[Item]
  end

  class ProductBacklog < T::Struct
    prop :icebox, ItemList
    prop :releases, T::Array[ItemList]
  end
end
