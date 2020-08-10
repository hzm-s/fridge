# typed: strict
require 'sorbet-runtime'

module PlanRepository
  module AR
    class << self
      extend T::Sig
      include Plan::PlanRepository

      sig {override.params(product_id: Product::Id).returns(Plan::Plan)}
      def find_by_product_id(product_id)
        r = Dao::Plan.find_by(dao_product_id: product_id.to_s)
        Plan::Plan.from_repository(
          Product::Id.from_string(r.dao_product_id),
          r.releases.map do |release|
            items = release['items'].map { |item| Pbi::Id.from_string(item) }
            Plan::Release.new(release['title'], items)
          end
        )
      end

      sig {override.params(plan: Plan::Plan).void}
      def add(plan)
        r = Dao::Plan.new(dao_product_id: plan.product_id.to_s)
        r.releases = plan.releases.map(&:to_h)
        r.save!
      end

      sig {override.params(plan: Plan::Plan).void}
      def update(plan)
        r = Dao::Plan.find_by(dao_product_id: plan.product_id.to_s)
        r.releases = plan.releases.map(&:to_h)
        r.save!
      end
    end
  end
end
