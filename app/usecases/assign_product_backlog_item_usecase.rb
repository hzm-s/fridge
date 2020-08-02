# typed: strict
require 'sorbet-runtime'

class AssignProductBacklogItemUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(ProductBacklogItemRepository::AR, Pbi::ItemRepository)
  end

  sig {params(pbi_id: Pbi::Id).void}
  def perform(pbi_id)
    pbi = @repository.find_by_id(pbi_id)
    pbi.assign
    @repository.update(pbi)
  end
end
