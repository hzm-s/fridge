# typed: false
require 'rails_helper'

RSpec.describe TeamQuery do
  let(:user_a) { register_user }
  let(:user_b) { register_user }
  let(:user_c) { register_user }
  let(:user_d) { register_user }
  let(:user_e) { register_user }

  let(:product_x) { create_product(user_id: user_a.id, role: Team::Role::ProductOwner) }
  let(:product_y) { create_product(user_id: user_d.id, role: Team::Role::ScrumMaster) }

  before do
    add_team_member(product_x.id, dev_member(user_c.id))
    add_team_member(product_x.id, dev_member(user_b.id))
    add_team_member(product_x.id, sm_member(user_d.id))

    add_team_member(product_y.id, po_member(user_a.id))
    add_team_member(product_y.id, dev_member(user_c.id))
    add_team_member(product_y.id, dev_member(user_e.id))
  end

  it do
    team = described_class.call(product_x.id.to_s)
    expect(team.map(&:user_id)).to eq [user_a, user_c, user_b, user_d].map(&:id).map(&:to_s)
  end

  it do
    team = described_class.call(product_x.id.to_s)

    aggregate_failures do
      expect(team.product_owner.user_id).to eq user_a.id.to_s
      expect(team.developers.map(&:user_id)).to eq [user_c, user_b].map(&:id).map(&:to_s)
      expect(team.scrum_master.user_id).to eq user_d.id.to_s
    end
  end

  it do
    member = described_class.call(product_x.id.to_s).first

    aggregate_failures do
      expect(member.role).to_not be_nil
      expect(member.name).to_not be_nil
      expect(member.initials).to_not be_nil
      expect(member.avatar_fg).to_not be_nil
      expect(member.avatar_bg).to_not be_nil
    end
  end
end
