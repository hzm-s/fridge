# typed: strict
require 'sorbet-runtime'

class AddTeamMemberUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(TeamRepository::AR, Team::TeamRepository)
  end

  sig {params(team_id: Team::Id, person_id: Person::Id, role: Team::Role).void}
  def perform(team_id, person_id, role)
    team = @repository.find_by_id(team_id)

    member = Team::Member.new(person_id, role)
    team.add_member(member)

    @repository.store(team)
  end
end
