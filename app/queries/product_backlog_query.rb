# typed: false

module ProductBacklogQuery
  class << self
    def call(product_id)
      issues = fetch_issues(product_id).map { |i| IssueStruct.new(i) }

      plan = fetch_plan(product_id)
      releases = plan.scoped.map { |r| ReleaseStruct.create(r, issues) }
      unscoped_items = plan.unscoped.map { |ui| issues.find { |i| i.id == ui.to_s } }

      ProductBacklog.new(scoped: releases, unscoped: unscoped_items)
    end

    private

    def fetch_issues(product_id)
      Dao::Issue.eager_load(:criteria).where(dao_product_id: product_id)
    end

    def fetch_plan(product_id)
      PlanRepository::AR.find_by_product_id(Product::Id.from_string(product_id))
    end
  end

  class ReleaseStruct < T::Struct
    class << self
      def create(release, issues)
        new(
          name: release.name,
          items: release.issues.map { |ri| issues.find { |i| i.id == ri.to_s } }
        )
      end
    end

    prop :name, String
    prop :items, T::Array[::IssueStruct]
  end

  class ProductBacklog < T::Struct
    prop :scoped, T::Array[ReleaseStruct]
    prop :unscoped, T::Array[::IssueStruct]
  end
end
