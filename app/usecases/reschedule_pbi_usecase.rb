# typed: strict
require 'sorbet-runtime'

class ReschedulePbiUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(product_id: Product::Id, roles: Team::RoleSet, pbi_id: Pbi::Id, release_number: Integer, to_index: Integer).void}
  def perform(product_id, roles, pbi_id, release_number, to_index)
    plan = @repository.find_by_product_id(product_id)

    from = plan.release_by_item(pbi_id)
    to = plan.release_of(release_number)

    from.drop_item(pbi_id)
    plan.update_release(roles, from)

    to.plan_item(pbi_id)
    if opposite = PlannedPbiQuery.call(plan, release_number, to_index)
      to.change_item_priority(pbi_id, opposite)
    end
    plan.update_release(roles, to)

    @repository.store(plan)
  end
end
