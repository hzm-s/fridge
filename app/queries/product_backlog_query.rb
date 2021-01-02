# typed: false

module ProductBacklogQuery
  class << self
    def call(product_id)
      issues = fetch_issues(product_id).map { |i| IssueStruct.new(i) }
      plan = fetch_plan(product_id)

      scheduled = plan.scheduled.to_a.map { |r| ReleaseStruct.create(r, issues) }
      pending = plan.pending.to_a.map { |pi| issues.find { |i| i.id == pi.to_s } }

      ProductBacklog.new(scheduled: scheduled, pending: pending)
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
          issues: release.issues.to_a.map { |ri| issues.find { |i| i.id == ri.to_s } }
        )
      end
    end

    prop :name, String
    prop :issues, T::Array[::IssueStruct]
  end

  class ProductBacklog < T::Struct
    prop :scheduled, T::Array[ReleaseStruct]
    prop :pending, T::Array[::IssueStruct]
  end
end
