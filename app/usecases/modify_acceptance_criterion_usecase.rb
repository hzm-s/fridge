# typed: strict
require 'sorbet-runtime'

class ModifyAcceptanceCriterionUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(PbiRepository::AR, Pbi::PbiRepository)
  end

  sig {params(pbi_id: Pbi::Id, number: Integer, content: Shared::ShortSentence).void}
  def perform(pbi_id, number, content)
    pbi = @repository.find_by_id(pbi_id)

    pbi.acceptance_criteria
      .then { |c| c.modify(number, content) }
      .then { |c| pbi.prepare_acceptance_criteria(c) }

    @repository.store(pbi)
  end
end
