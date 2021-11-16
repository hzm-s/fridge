# typed: strict
require 'sorbet-runtime'

class EstimatePbiUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(PbiRepository::AR, Pbi::PbiRepository)
  end

  sig {params(id: Pbi::Id, roles: Team::RoleSet, size: Pbi::StoryPoint).void}
  def perform(id, roles, size)
    pbi = @repository.find_by_id(id)
    pbi.estimate(roles, size)

    @repository.store(pbi)
  end
end
