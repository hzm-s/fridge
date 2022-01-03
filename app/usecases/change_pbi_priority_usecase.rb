# typed: strict
require 'sorbet-runtime'

class ChangePbiPriorityUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(product_id: Product::Id, roles: Team::RoleSet, from: Pbi::Id, to: Pbi::Id).void}
  def perform(product_id, roles, from, to)
    new_plan =
      @repository.find_by_product_id(product_id)
        .then { |plan| [plan, Plan::ChangePlan.new(roles)] }
        .then { |plan, c| c.change_item_priority(plan, from, to) }

    @repository.store(new_plan)
  end
end
