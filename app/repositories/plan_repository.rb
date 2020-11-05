# typed: strict
require 'sorbet-runtime'

module PlanRepository
  class AR
    class << self
      extend T::Sig
      include Plan::PlanRepository

      sig {override.params(product_id: Product::Id).returns(Plan::Plan)}
      def find_by_product_id(product_id)
        Dao::Order.find_by(dao_product_id: product_id.to_s).read
      end

      sig {override.params(plan: Plan::Plan).void}
      def store(plan)
        dao_order = Dao::Order.find_or_initialize_by(dao_product_id: plan.product_id.to_s)
        dao_order.write(plan)

        dao_old_scopes = Dao::Scope.where(dao_product_id: plan.product_id.to_s)
        dao_new_scopes = plan.scopes.to_a.map do |s|
          Dao::Scope.new(
            dao_product_id: plan.product_id.to_s,
            release_id: s.release_id.to_s,
            tail: s.tail.to_s
          )
        end

        ApplicationRecord.transaction do
          dao_order.save!
          dao_old_scopes.destroy_all
          dao_new_scopes.each(&:save!)
        end
      end
    end
  end
end
