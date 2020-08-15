# typed: strict
require 'sorbet-runtime'

class AddProductBacklogItemUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @pbi_repository = T.let(ProductBacklogItemRepository::AR, Pbi::ItemRepository)
    @release_repository = T.let(ReleaseRepository::AR, Release::ReleaseRepository)
  end

  sig {params(product_id: Product::Id, content: Pbi::Content).returns(Pbi::Id)}
  def perform(product_id, content)
    pbi = Pbi::Item.create(product_id, content)

    transaction do
      release = fetch_release(product_id)
      release.add_item(pbi.id)
      @pbi_repository.add(pbi)
      @release_repository.save(release)
    end

    pbi.id
  end

  private

  sig {params(product_id: Product::Id).returns(Release::Release)}
  def fetch_release(product_id)
    plan = @release_repository.find_plan_by_product_id(product_id)
    return Release::Release.create_default(product_id) if plan.empty?

    plan.last
  end
end
