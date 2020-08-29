# typed: strict
require 'sorbet-runtime'

class StartPbiDevelopmentUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(PbiRepository::AR, Pbi::PbiRepository)
  end

  sig {params(id: Pbi::Id).void}
  def perform(id)
    pbi = @repository.find_by_id(id)
    pbi.start_development
    @repository.update(pbi)
  end
end
