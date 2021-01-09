# typed: false
require 'rails_helper'

RSpec.describe TeamQuery do
  let(:person_a) { sign_up_as_person }
  let(:person_b) { sign_up_as_person }
  let(:person_c) { sign_up_as_person }
  let(:person_d) { sign_up_as_person }
  let(:person_e) { sign_up_as_person }

  let!(:product_x) do
    create_product(
      person: person_a.id,
      roles: team_roles(:po),
      members: [
        dev_member(person_c.id),
        dev_member(person_b.id),
        sm_member(person_d.id)
      ]
    )
  end

  let!(:product_y) do
    create_product(
      person: person_d.id,
      roles: team_roles(:po),
      members: [
        sm_member(person_a.id),
        dev_member(person_c.id),
        dev_member(person_e.id)
      ]
    )
  end

  it do
    team = described_class.call(resolve_team(product_x.id).id.to_s)
    expect(team.members.map(&:person_id)).to eq [person_a, person_c, person_b, person_d].map(&:id).map(&:to_s)
  end

  it do
    team = described_class.call(resolve_team(product_x.id).id.to_s)

    aggregate_failures do
      expect(team.product_owner.person_id).to eq person_a.id.to_s
      expect(team.developers.map(&:person_id)).to eq [person_c, person_b].map(&:id).map(&:to_s)
      expect(team.scrum_master.person_id).to eq person_d.id.to_s
    end
  end
end
