# typed: strict
require 'sorbet-runtime'

class ReschedulePbiUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(product_id: Product::Id, roles: Team::RoleSet, from: Pbi::Id, release_number: Integer, to: T.nilable(Pbi::Id)).void}
  def perform(product_id, roles, from, release_number, to)
    new_plan =
      @repository.find_by_product_id(product_id)
        .then { |plan| [plan, Plan::ChangePlan.new(roles)] }
        .then { |plan, c| c.reschedule(plan, from, release_number, to) }

    @repository.store(new_plan)
  end
end
