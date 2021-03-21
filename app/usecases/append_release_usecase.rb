# typed: strict
require 'sorbet-runtime'

class AppendReleaseUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(roles: Team::RoleSet, product_id: Product::Id).void}
  def perform(roles, product_id)
    plan = @repository.find_by_product_id(product_id)
    plan.append_release
    @repository.store(plan)
  end
end
