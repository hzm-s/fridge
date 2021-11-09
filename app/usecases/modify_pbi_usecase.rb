# typed: strict
require 'sorbet-runtime'

class ModifyPbiUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(PbiRepository::AR, Pbi::PbiRepository)
  end

  sig {params(pbi_id: Pbi::Id, description: Shared::LongSentence).void}
  def perform(pbi_id, description)
    pbi = @repository.find_by_id(pbi_id)
    pbi.modify_description(description)
    @repository.store(pbi)
  end
end
