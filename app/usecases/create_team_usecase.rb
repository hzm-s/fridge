# typed: strict
require 'sorbet-runtime'

class CreateTeamUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(TeamRepository::AR, Team::TeamRepository)
  end

  sig {params(person_id: Person::Id, roles: Team::RoleSet, name: Shared::Name).returns(Team::Id)}
  def perform(person_id, roles, name)
    team = Team::Team.create(name)
    team.add_member(Team::Member.new(person_id, roles))

    @repository.store(team)

    team.id
  end
end
