# typed: strict
require 'sorbet-runtime'

class RemovePbiUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @pbi_repository = T.let(PbiRepository::AR, Pbi::PbiRepository)
    @plan_repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(pbi_id: Pbi::Id).void}
  def perform(pbi_id)
    pbi = @pbi_repository.find_by_id(pbi_id)
    raise Pbi::CanNotRemove unless pbi.status.can_remove?

    plan = @plan_repository.find_by_product_id(pbi.product_id)
    no = plan.find_release_no_by_item(pbi.id)
    release = plan.release(no)
    release.remove_item(pbi.id)
    plan.replace_release(no, release)

    transaction do
      @pbi_repository.delete(pbi.id)
      @plan_repository.update(plan)
    end
  end
end
