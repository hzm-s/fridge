# typed: strict
require 'sorbet-runtime'

class PreparePlanUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(product_id: Product::Id).void}
  def perform(product_id)
    plan = Plan::Plan.create(product_id)
    @repository.store(plan)
  end
end
