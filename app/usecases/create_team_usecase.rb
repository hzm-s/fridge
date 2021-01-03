# typed: strict
require 'sorbet-runtime'

class CreateTeamUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(TeamRepository::AR, Team::TeamRepository)
  end

  sig {params(person_id: Person::Id, role: Team::Role, name: String).returns(Team::Id)}
  def perform(person_id, role, name)
    team = Team::Team.create(name)
    team.add_member(Team::Member.new(person_id, role))

    @repository.store(team)

    team.id
  end
end
