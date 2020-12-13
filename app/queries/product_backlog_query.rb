# typed: false

module ProductBacklogQuery
  class << self
    def call(product_id)
      issues = fetch_issues(product_id).map { |i| IssueStruct.new(i) }
      plan = fetch_plan(product_id)

      scoped = plan.releases.map { |r| ReleaseStruct.create(r, issues) }
      not_scoped = plan.not_scoped_issues.map { |pi| issues.find { |i| i.id == pi } }

      ProductBacklog.new(scoped: scoped, not_scoped: not_scoped)
    end

    private

    def fetch_issues(product_id)
      Dao::Issue.eager_load(:criteria).where(dao_product_id: product_id)
    end

    def fetch_plan(product_id)
      Dao::Plan.eager_load(:releases).find_by(dao_product_id: product_id)
    end
  end

  class ReleaseStruct < T::Struct
    class << self
      def create(release, issues)
        new(
          name: release.name,
          issues: release.issues.map { |ri| issues.find { |i| i.id == ri.to_s } }
        )
      end
    end

    prop :name, String
    prop :issues, T::Array[::IssueStruct]
  end

  class ProductBacklog < T::Struct
    prop :scoped, T::Array[ReleaseStruct]
    prop :not_scoped, T::Array[::IssueStruct]
  end
end
