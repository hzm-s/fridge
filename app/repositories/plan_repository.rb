# typed: strict
require 'sorbet-runtime'

module PlanRepository
  class AR
    class << self
      extend T::Sig
      include Plan::PlanRepository

      sig {override.params(product_id: Product::Id).returns(Plan::Plan)}
      def find_by_product_id(product_id)
        daos = Dao::Release.where(dao_product_id: product_id.to_s).order(:number)
        Dao::Release.read(daos)
      end

      sig {override.params(plan: Plan::Plan).void}
      def store(plan)
        plan.releases.each do |r|
          dao = Dao::Release.find_or_initialize_by(dao_product_id: plan.product_id.to_s, number: r.number)
          dao.write(r)
          dao.save!
        end
        Dao::Release.sync(plan.product_id.to_s, plan.releases.map(&:number))
      end
    end
  end
end
