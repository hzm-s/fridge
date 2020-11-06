# typed: strict
require 'sorbet-runtime'

module PlanRepository
  class AR
    class << self
      extend T::Sig
      include Plan::PlanRepository

      sig {override.params(product_id: Product::Id).returns(Plan::Plan)}
      def find_by_product_id(product_id)
        Dao::Plan.find_by(dao_product_id: product_id.to_s).read
      end

      sig {override.params(plan: Plan::Plan).void}
      def store(plan)
        dao = Dao::Plan.find_or_initialize_by(dao_product_id: plan.product_id.to_s)
        dao.write(plan)
        dao.save!
      end
    end
  end
end
