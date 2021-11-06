# typed: strict
require 'sorbet-runtime'

class AppendAcceptanceCriterionUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(PbiRepository::AR, Pbi::PbiRepository)
  end

  sig {params(pbi_id: Pbi::Id, content: Shared::ShortSentence).void}
  def perform(pbi_id, content)
    pbi = @repository.find_by_id(pbi_id)

    pbi.acceptance_criteria.append(content)
      .then { |c| pbi.prepare_acceptance_criteria(c) }

    @repository.store(pbi)
  end
end
