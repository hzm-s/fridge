# typed: strict
require 'sorbet-runtime'

module PlanRepository
  class AR
    class << self
      extend T::Sig
      include Plan::PlanRepository

      sig {override.params(plan: Plan::Plan).void}
      def store(plan)
        dao = Dao::Release.find_or_initialize_by(dao_product_id: release.product_id.to_s, number: release.number)
        dao.write(release)
        dao.save!
      end
    end
  end
end
