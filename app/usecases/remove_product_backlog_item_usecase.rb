# typed: true
require 'sorbet-runtime'

class RemoveProductBacklogItemUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(ProductBacklogItemRepository::AR, Pbi::ItemRepository)
  end

  sig {params(pbi_id: Pbi::Id).void}
  def perform(pbi_id)
    @repository.delete(pbi_id)
  end
end
