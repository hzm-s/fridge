# typed: strict
require 'sorbet-runtime'

class RemoveAcceptanceCriterionUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(PbiRepository::AR, Pbi::PbiRepository)
  end

  sig {params(pbi_id: Pbi::Id, number: Integer).void}
  def perform(pbi_id, number)
    pbi = @repository.find_by_id(pbi_id)

    criteria = pbi.acceptance_criteria
    pbi.prepare_acceptance_criteria(criteria.remove(number))

    @repository.store(pbi)
  end
end
