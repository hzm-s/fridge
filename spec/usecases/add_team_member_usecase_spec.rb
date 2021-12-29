# typed: false
require 'rails_helper'

describe AddTeamMemberUsecase do
  let!(:product) { create_product(members: [sm_member(sign_up_as_person.id)]) }
  let(:team) { resolve_team(product.id) }
  let(:new_person) { sign_up_as_person }

  it do
    roles = Team::RoleSet.new([Team::Role::Developer])

    described_class.perform(team.id, new_person.id, roles)

    stored = TeamRepository::AR.find_by_id(team.id)
    new_member = stored.member(new_person.id)

    expect(new_member.roles).to eq roles
  end
end
