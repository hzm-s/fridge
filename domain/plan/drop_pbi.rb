# typed: strict
require 'sorbet-runtime'

module Plan
  class DropPbi
    extend T::Sig

    sig {params(pbi_repository: Pbi::PbiRepository, plan_repository: PlanRepository).void}
    def initialize(pbi_repository, plan_repository)
      @pbi_repository = pbi_repository
      @plan_repository = plan_repository
    end

    sig {params(product_id: Product::Id, roles: Team::RoleSet, pbi_id: Pbi::Id).void}
    def drop(product_id, roles, pbi_id)
      plan = @plan_repository.find_by_product_id(product_id)
      plan.release_by_item(pbi_id).tap do |r|
        r.drop_item(pbi_id)
        plan.update_release(roles, r)
      end
      @plan_repository.store(plan)

      @pbi_repository.remove(pbi_id)
    end
  end
end
