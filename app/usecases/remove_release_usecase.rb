# typed: strict
require 'sorbet-runtime'

class RemoveReleaseUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(product_id: Product::Id, no: Integer).void}
  def perform(product_id, no)
    plan = @repository.find_by_product_id(product_id)
    plan.remove_release(no)
    @repository.update(plan)

    #raise Release::CanNotRemoveRelease unless release.can_remove? 
  end
end
