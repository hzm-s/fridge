# typed: strict
require 'sorbet-runtime'

class RemoveAcceptanceCriterionUsecase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(ProductBacklogItemRepository::AR, Pbi::ItemRepository)
  end

  sig {params(pbi_id: Pbi::Id, no: Integer).void}
  def perform(pbi_id, no)
    pbi = @repository.find_by_id(pbi_id)
    pbi.remove_acceptance_criterion(no)
    @repository.update(pbi)
  end
end
