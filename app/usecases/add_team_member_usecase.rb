# typed: strict
require 'sorbet-runtime'

class AddTeamMemberUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(TeamRepository::AR, Team::TeamRepository)
  end

  sig {params(team_id: Team::Id, person_id: Person::Id, roles: Team::RoleSet).void}
  def perform(team_id, person_id, roles)
    team = @repository.find_by_id(team_id)

    member = Team::Member.new(person_id, roles)
    team.add_member(member)

    @repository.store(team)
  end
end
