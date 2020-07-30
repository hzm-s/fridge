# typed: strict
require 'sorbet-runtime'

class AddAcceptanceCriterionUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(ProductBacklogItemRepository::AR, Pbi::ItemRepository)
  end

  sig {params(pbi_id: Pbi::Id, criterion: Pbi::AcceptanceCriterion).void}
  def perform(pbi_id, criterion)
    pbi = @repository.find_by_id(pbi_id)
    pbi.add_acceptance_criterion(criterion)
    @repository.update(pbi)
  end
end
