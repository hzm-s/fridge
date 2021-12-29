# typed: false
require 'rails_helper'

describe CreateTeamUsecase do
  let(:person) { sign_up_as_person }

  it do
    roles = Team::RoleSet.new([Team::Role::ProductOwner, Team::Role::ScrumMaster])
    team_id = described_class.perform(person.id, roles, name('ABC'))

    team = TeamRepository::AR.find_by_id(team_id)

    aggregate_failures do
      expect(team.name.to_s).to eq 'ABC'
      expect(team.members).to match_array [team_member(person.id, :po, :sm)]
      expect(team.product).to be_nil
    end
  end
end
