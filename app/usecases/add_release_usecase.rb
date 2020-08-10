# typed: strict
require 'sorbet-runtime'

class AddReleaseUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(product_id: Product::Id, title: String).void}
  def perform(product_id, title)
    plan = @repository.find_by_product_id(product_id)
    plan.add_release(title)
    @repository.update(plan)
  end
end
