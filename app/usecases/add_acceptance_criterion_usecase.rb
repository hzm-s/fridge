# typed: strict
require 'sorbet-runtime'

class AddAcceptanceCriterionUsecase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(ProductBacklogItemRepository::AR, Pbi::ItemRepository)
  end

  sig {params(pbi_id: Pbi::ItemId, content: String).void}
  def perform(pbi_id, content)
    pbi = @repository.find_by_id(pbi_id)
    pbi.add_acceptance_criterion(content)
    @repository.update(pbi)
  end
end