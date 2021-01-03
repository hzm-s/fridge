# typed: strict
require 'sorbet-runtime'

class CreateProductTeamUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(TeamRepository::AR, Team::TeamRepository)
  end

  sig {params(product_id: Product::Id, name: String).returns(Team::Id)}
  def perform(product_id, name)
    team = Team::Team.create(name)
    team.develop(product_id)
    @repository.store(team)
    team.id
  end
end
