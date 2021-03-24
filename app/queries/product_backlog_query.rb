# typed: false
module ProductBacklogQuery
  class << self
    def call(product_id)
      issues = fetch_issues(product_id).map { |i| IssueStruct.new(i) }
      plan = fetch_plan(product_id)

      releases = plan.releases.map { |r| ReleaseStruct.create(r, issues) }

      ProductBacklog.new(releases: releases)
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
    prop :number, Integer
    prop :issues, T::Array[::IssueStruct]
    prop :can_remove, T::Boolean

    class << self
      def create(release, all_issues)
        new(
          number: release.number,
          issues: release.issues.to_a.map { |ri| all_issues.find { |i| i.id == ri.to_s } },
          can_remove: release.can_remove?,
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
