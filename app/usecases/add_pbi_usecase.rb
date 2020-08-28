# typed: strict
require 'sorbet-runtime'

class AddPbiUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @pbi_repository = T.let(PbiRepository::AR, Pbi::PbiRepository)
    @plan_repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(product_id: Product::Id, description: Pbi::Description).returns(Pbi::Id)}
  def perform(product_id, description)
    pbi = Pbi::Pbi.create(product_id, description)

    plan = @plan_repository.find_by_product_id(product_id)
    release = plan.release(1)
    release.add_item(pbi.id)
    plan.replace_release(1, release)

    transaction do
      @pbi_repository.add(pbi)
      @plan_repository.update(plan)
    end

    pbi.id
  end
end
