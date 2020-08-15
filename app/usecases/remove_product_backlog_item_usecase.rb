# typed: strict
require 'sorbet-runtime'

class RemoveProductBacklogItemUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @pbi_repository = T.let(ProductBacklogItemRepository::AR, Pbi::ItemRepository)
    @release_repository = T.let(ReleaseRepository::AR, Release::ReleaseRepository)
  end

  sig {params(pbi_id: Pbi::Id).void}
  def perform(pbi_id)
    pbi = @pbi_repository.find_by_id(pbi_id)
    raise Pbi::ItemCanNotRemove unless pbi.status.can_remove?

    plan = @release_repository.find_plan_by_product_id(pbi.product_id)
    return if plan.empty?

    release = T.must(plan.find { |release| release.items.include?(pbi_id) })
    release.remove_item(pbi.id)

    transaction do
      @pbi_repository.delete(pbi_id)
      @release_repository.update(release)
    end
  end
end
