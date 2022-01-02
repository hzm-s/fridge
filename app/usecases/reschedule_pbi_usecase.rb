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
    plan = @repository.find_by_product_id(product_id)

    from_release = plan.release_by_item(from)
    to_release = plan.release_of(release_number)

    from_release.drop_item(from)
      .then { |r| plan.update_release(roles, r) }

    to_release.plan_item(from).then do |planned|
      if to
        planned.change_item_priority(from, to)
      else
        planned
      end
    end
      .then { |r| plan.update_release(roles, r) }

    @repository.store(plan)
  end
end
