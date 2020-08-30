# typed: strict
require 'sorbet-runtime'

class AddPbiUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @pbi_repository = T.let(PbiRepository::AR, Pbi::PbiRepository)
    @plan_repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(product_id: Product::Id, description: Pbi::Description, release_no: Integer).returns(Pbi::Id)}
  def perform(product_id, description, release_no = 1)
    pbi = Pbi::Pbi.create(product_id, description)
    plan = update_plan(product_id, pbi.id, release_no)

    transaction do
      @pbi_repository.add(pbi)
      @plan_repository.update(plan)
    end

    pbi.id
  end

  private

  sig {params(product_id: Product::Id, pbi_id: Pbi::Id, release_no: Integer).returns(Plan::Plan)}
  def update_plan(product_id, pbi_id, release_no)
    plan = @plan_repository.find_by_product_id(product_id)

    release = plan.release(release_no)
    release.add_item(pbi_id)

    plan.replace_release(release_no, release)
    plan
  end
end
