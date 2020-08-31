# typed: strict
require 'sorbet-runtime'

class CreateTeamUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(TeamRepository::AR, Team::TeamRepository)
  end

  sig {params(name: String, person_id: Person::Id, role: Team::Role).returns(Team::Id)}
  def perform(name, person_id, role)
    team = Team::Team.create(name)

    member = Team::Member.new(person_id, role)
    team.add_member(member)

    @repository.add(team)

    team.id
  end
end
