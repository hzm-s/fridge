# typed: strict
require 'sorbet-runtime'

class ModifyReleaseDescriptionUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(roles: Team::RoleSet, product_id: Product::Id, release_number: Integer, description: String).void}
  def perform(roles, product_id, release_number, description)
    plan = @repository.find_by_product_id(product_id)
    plan.release_of(release_number).tap do |r|
      r.modify_description(description)
      plan.update_release(r)
    end
    @repository.store(plan)
  end
end
