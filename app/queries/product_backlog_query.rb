# typed: false
module ProductBacklogQuery
  class << self
    def call(product_id)
      items = fetch_pbis(product_id).map { |p| PbiStruct.new(p) }
      plan = fetch_plan(product_id)

      releases = plan.releases.map { |r| ReleaseStruct.create(r, items, plan) }

      ProductBacklog.new(releases: releases)
    end

    private

    def fetch_pbis(product_id)
      Dao::Pbi.eager_load(:criteria).where(dao_product_id: product_id)
    end

    def fetch_plan(product_id)
      PlanRepository::AR.find_by_product_id(Product::Id.from_string(product_id))
    end
  end

  class ReleaseStruct < T::Struct
    prop :number, Integer
    prop :title, T.nilable(String)
    prop :items, T::Array[::PbiStruct]
    prop :can_remove, T::Boolean

    class << self
      def create(release, all_items, plan)
        new(
          number: release.number,
          title: release.title.to_s,
          items: release.items.to_a.map { |ri| all_items.find { |i| i.id == ri.to_s } },
          can_remove: plan.can_remove_release? && release.can_remove?,
        )
      end
    end

    def can_remove?
      can_remove
    end
  end

  class ProductBacklog < T::Struct
    prop :releases, T::Array[ReleaseStruct]
  end
end
