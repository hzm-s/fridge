# typed: strict
require 'sorbet-runtime'

module PlanRepository
  module AR
    class << self
      extend T::Sig
      include Plan::PlanRepository

      sig {override.params(product_id: Product::Id).returns(Plan::Plan)}
      def find_by_product_id(product_id)
        rels = Dao::Release.where(dao_product_id: product_id.to_s).order(:id)

        releases = rels.map do |rel|
          Plan::Release.from_repository(
            rel.title,
            rel.items.map { |i| Pbi::Id.from_string(i) }
          )
        end

        Plan::Plan.from_repository(
          Product::Id.from_string(rels.first.dao_product_id),
          releases
        )
      end

      sig {override.params(plan: Plan::Plan).void}
      def add(plan)
        plan.releases.each do |release|
          rel = Dao::Release.new(
            dao_product_id: plan.product_id.to_s,
            title: release.title,
          )
          rel.items = release.items.map(&:to_s)
          rel.save!
        end
      end

      sig {override.params(plan: Plan::Plan).void}
      def update(plan)
        Dao::Release.where(dao_product_id: plan.product_id.to_s).destroy_all

        add(plan)
      end
    end
  end
end
