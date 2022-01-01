# typed: strict
require 'sorbet-runtime'

class DropPbiUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @pbi_repository = T.let(PbiRepository::AR, Pbi::PbiRepository)
    @plan_repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(product_id: Product::Id, roles: Team::RoleSet, pbi_id: Pbi::Id).void}
  def perform(product_id, roles, pbi_id)
    plan = @plan_repository.find_by_product_id(product_id)

    plan.release_by_item(pbi_id)
      .then { |release| release.drop_item(pbi_id) }
      .then { |release| plan.update_release(roles, release) }

    @plan_repository.store(plan)
    @pbi_repository.remove(pbi_id)
  end
end
