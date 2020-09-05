# typed: false
require 'rails_helper'

RSpec.describe AddTeamMemberUsecase do
  let!(:product) { create_product(members: [sm_member(sign_up_as_person.id)]) }
  let(:team) { resolve_team(product.id) }
  let(:new_person) { sign_up_as_person }

  it do
    described_class.perform(team.id, new_person.id, Team::Role::Developer)

    stored = TeamRepository::AR.find_by_id(team.id)
    new_member = stored.member(new_person.id)

    expect(new_member.role).to eq Team::Role::Developer
  end
end
