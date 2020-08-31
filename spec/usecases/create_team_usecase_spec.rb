# typed: false
require 'rails_helper'

RSpec.describe CreateTeamUsecase do
  let(:person) { sign_up_as_person }

  it do
    team_id = described_class.perform('ABC', person.id, Team::Role.from_string('developer'))

    team = TeamRepository::AR.find_by_id(team_id)

    expect(team.name).to eq 'ABC'
    expect(team.member(person.id)).to eq dev_member(person.id)
  end
end
