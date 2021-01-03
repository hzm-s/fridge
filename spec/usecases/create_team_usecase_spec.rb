# typed: false
require 'rails_helper'

RSpec.describe CreateTeamUsecase do
  let(:person) { sign_up_as_person }

  it do
    team_id = described_class.perform(person.id, Team::Role::ProductOwner, 'ABC')

    team = TeamRepository::AR.find_by_id(team_id)

    aggregate_failures do
      expect(team.name).to eq 'ABC'
      expect(team.members).to match_array [po_member(person.id)]
      expect(team.product).to be_nil
    end
  end
end
