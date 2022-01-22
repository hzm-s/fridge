# typed: false
module ProductBacklogQuery
  class << self
    def call(product_id)
      items = fetch_pbis(product_id).map { |p| PbiStruct.new(p) }
      roadmap = fetch_roadmap(product_id)

      releases = roadmap.releases.map { |r| ReleaseStruct.create(r, items, roadmap) }

      ProductBacklog.new(releases: releases)
    end

    private

    def fetch_pbis(product_id)
      Dao::Pbi.eager_load(:criteria).where(dao_product_id: product_id)
    end

    def fetch_roadmap(product_id)
      RoadmapRepository::AR.find_by_product_id(Product::Id.from_string(product_id))
    end
  end

  class ReleaseStruct < T::Struct
    prop :number, Integer
    prop :title, T.nilable(String)
    prop :items, T::Array[::PbiStruct]
    prop :can_remove, T::Boolean

    class << self
      def create(release, all_items, roadmap)
        new(
          number: release.number,
          title: release.title.to_s,
          items: release.items.to_a.map { |ri| all_items.find { |i| i.id == ri.to_s } },
          can_remove: roadmap.can_remove_release? && release.can_remove?,
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
