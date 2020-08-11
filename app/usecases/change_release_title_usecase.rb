# typed: strict
require 'sorbet-runtime'

class ChangeReleaseTitleUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(product_id: Product::Id, release: Integer, title: String).void}
  def perform(product_id, release, title)
    plan = T.must(@repository.find_by_product_id(product_id))
    plan.change_release_title(release, title)
    @repository.update(plan)
  end
end
