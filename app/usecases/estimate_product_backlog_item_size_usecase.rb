# typed: strict
require 'sorbet-runtime'

class EstimateProductBacklogItemSizeUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(ProductBacklogItemRepository::AR, Pbi::ItemRepository)
  end

  sig {params(id: Pbi::Id, point: Pbi::StoryPoint).returns(Pbi::Id)}
  def perform(id, point)
    pbi = @repository.find_by_id(id)
    pbi.estimate_size(point)

    @repository.update(pbi)

    pbi.id
  end
end
