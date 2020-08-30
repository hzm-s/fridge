# typed: strict
require 'sorbet-runtime'

class AbortPbiDevelopmentUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(PbiRepository::AR, Pbi::PbiRepository)
  end

  sig {params(id: Pbi::Id).void}
  def perform(id)
    pbi = @repository.find_by_id(id)
    pbi.abort_development
    @repository.update(pbi)
  end
end
