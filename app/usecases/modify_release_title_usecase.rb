# typed: strict
require 'sorbet-runtime'

class ModifyReleaseTitleUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(product_id: Product::Id, no: Integer, title: String).void}
  def perform(product_id, no, title)
    plan = @repository.find_by_product_id(product_id)

    release = plan.release(no)
    release.modify_title(title)

    plan.replace_release(no, release)
    @repository.update(plan)
  end
end
