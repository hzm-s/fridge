# typed: strict
require 'sorbet-runtime'

class AddAcceptanceCriterionUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(PbiRepository::AR, Pbi::PbiRepository)
  end

  sig {params(pbi_id: Pbi::Id, criterion: Pbi::AcceptanceCriterion).void}
  def perform(pbi_id, criterion)
    pbi = @repository.find_by_id(pbi_id)

    criteria = pbi.acceptance_criteria.append(criterion)
    pbi.update_acceptance_criteria(criteria)

    @repository.update(pbi)
  end
end
