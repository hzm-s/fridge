# typed: strict
require 'sorbet-runtime'

class AppendReleaseUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(roles: Team::RoleSet, product_id: Product::Id, description: T.nilable(String)).void}
  def perform(roles, product_id, description)
    plan = @repository.find_by_product_id(product_id)
    plan.append_release(description)
    @repository.store(plan)
  end
end
