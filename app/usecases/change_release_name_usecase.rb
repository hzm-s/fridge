# typed: strict
require 'sorbet-runtime'

class ChangeReleaseNameUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(product_id: Product::Id, roles: Team::RoleSet, new_name: String, old_name: String).void}
  def perform(product_id, roles, new_name, old_name)
    plan = @repository.find_by_product_id(product_id)

    new_scheduled = plan.scheduled.change_release_name(new_name, old_name)
    plan.update_scheduled(roles, new_scheduled)

    @repository.store(plan)
  end
end
