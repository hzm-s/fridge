# typed: strict
require 'sorbet-runtime'

class ChangePbiPriorityUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(product_id: Product::Id, roles: Team::RoleSet, pbi_id: Pbi::Id, to_index: Integer).void}
  def perform(product_id, roles, pbi_id, to_index)
    plan = @repository.find_by_product_id(product_id)

    release = plan.release_by_item(pbi_id)
    opposite = T.must(PlannedPbiQuery.call(plan, release.number, to_index))

    release.change_item_priority(pbi_id, opposite)
      .then { |release| plan.update_release(roles, release) }

    @repository.store(plan)
  end
end
