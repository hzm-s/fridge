# typed: false
require 'rails_helper'

RSpec.describe TeamQuery do
  let(:person_a) { sign_up_as_person }
  let(:person_b) { sign_up_as_person }
  let(:person_c) { sign_up_as_person }
  let(:person_d) { sign_up_as_person }
  let(:person_e) { sign_up_as_person }

  let(:product_x) { create_product(owner: person_a.id, role: Team::Role::ProductOwner) }
  let(:product_y) { create_product(owner: person_d.id, role: Team::Role::ScrumMaster) }

  before do
    add_team_member(product_x.id, dev_member(person_c.id))
    add_team_member(product_x.id, dev_member(person_b.id))
    add_team_member(product_x.id, sm_member(person_d.id))

    add_team_member(product_y.id, po_member(person_a.id))
    add_team_member(product_y.id, dev_member(person_c.id))
    add_team_member(product_y.id, dev_member(person_e.id))
  end

  it do
    team = described_class.call(product_x.id.to_s)
    expect(team.map(&:person_id)).to eq [person_a, person_c, person_b, person_d].map(&:id).map(&:to_s)
  end

  it do
    team = described_class.call(product_x.id.to_s)

    aggregate_failures do
      expect(team.product_owner.person_id).to eq person_a.id.to_s
      expect(team.developers.map(&:person_id)).to eq [person_c, person_b].map(&:id).map(&:to_s)
      expect(team.scrum_master.person_id).to eq person_d.id.to_s
    end
  end

  it do
    member = described_class.call(product_x.id.to_s).first

    aggregate_failures do
      expect(member.role).to_not be_nil
      expect(member.name).to_not be_nil
      expect(member.avatar).to_not be_nil
    end
  end
end
