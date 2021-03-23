# typed: strict
require 'sorbet-runtime'

class RemoveReleaseUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(product_id: Product::Id, roles: Team::RoleSet, release_number: Integer).void}
  def perform(product_id, roles, release_number)
    plan = @repository.find_by_product_id(product_id)

    plan.remove_release(release_number)

    @repository.store(plan)
  end
end
