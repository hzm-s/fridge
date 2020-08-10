# typed: strict
require 'sorbet-runtime'

class RemoveProductBacklogItemUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @pbi_repository = T.let(ProductBacklogItemRepository::AR, Pbi::ItemRepository)
    @plan_repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(pbi_id: Pbi::Id).void}
  def perform(pbi_id)
    pbi = @pbi_repository.find_by_id(pbi_id)
    raise Pbi::ItemCanNotRemove unless pbi.status.can_remove?

    plan = @plan_repository.find_by_product_id(pbi.product_id)
    return unless plan

    plan.remove_item(pbi.id)

    transaction do
      @pbi_repository.delete(pbi_id)
      @plan_repository.update(plan)
    end
  end
end
