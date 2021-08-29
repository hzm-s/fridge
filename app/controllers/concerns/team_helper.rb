# typed: true
module TeamHelper
  def available_team_roles(team_id)
    Team::Id.from_string(team_id)
      .then { |id| TeamRepository::AR.find_by_id(id) }
      .then { |t| t.available_roles }
  end

  def all_team_roles
    Team::Team.create('dummy').available_roles
  end
end
