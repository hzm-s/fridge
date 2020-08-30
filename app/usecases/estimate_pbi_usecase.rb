# typed: strict
require 'sorbet-runtime'

class EstimatePbiUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(PbiRepository::AR, Pbi::PbiRepository)
  end

  sig {params(id: Pbi::Id, point: Pbi::StoryPoint).returns(Pbi::Id)}
  def perform(id, point)
    pbi = @repository.find_by_id(id)
    pbi.estimate(point)

    @repository.update(pbi)

    pbi.id
  end
end
