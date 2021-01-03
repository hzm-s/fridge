# typed: false
require 'rails_helper'

RSpec.describe TeamRepository::AR, type: :repository do
  let(:product) { create_product }
  let(:person_a) { sign_up }
  let(:person_b) { sign_up }
  let(:person_c) { sign_up }
  let(:person_d) { sign_up }

  describe 'add' do
    it do
      team = Team::Team.create('The Team')
      team.develop(product.id)
      team.add_member(po_member(person_a.person_id))
      team.add_member(sm_member(person_b.person_id))
      team.add_member(dev_member(person_c.person_id))

      described_class.add(team)

      team_rels = Dao::Team.all
      expect(team_rels.size).to eq 1
      expect(team_rels[0].dao_product_id).to eq product.id.to_s
      expect(team_rels[0].name).to eq 'The Team'

      member_rels = Dao::TeamMember.all
      expect(member_rels.size).to eq 3
      expect(member_rels[0].dao_person_id).to eq person_a.person_id.to_s
      expect(member_rels[0].role).to eq 'product_owner'
      expect(member_rels[1].dao_person_id).to eq person_b.person_id.to_s
      expect(member_rels[1].role).to eq 'scrum_master'
      expect(member_rels[2].dao_person_id).to eq person_c.person_id.to_s
      expect(member_rels[2].role).to eq 'developer'
    end
  end

  describe 'update' do
    it do
      team = Team::Team.create('The Team')
      team.develop(product.id)
      team.add_member(po_member(person_a.person_id))
      team.add_member(sm_member(person_b.person_id))
      team.add_member(dev_member(person_c.person_id))
      described_class.add(team)

      team.add_member(dev_member(person_d.person_id))

      described_class.update(team)

      team_rels = Dao::Team.all
      expect(team_rels.size).to eq 1
      expect(team_rels[0].dao_product_id).to eq product.id.to_s
      expect(team_rels[0].name).to eq 'The Team'

      member_rels = Dao::TeamMember.all
      expect(member_rels.size).to eq 4
      expect(member_rels[0].dao_person_id).to eq person_a.person_id.to_s
      expect(member_rels[0].role).to eq 'product_owner'
      expect(member_rels[1].dao_person_id).to eq person_b.person_id.to_s
      expect(member_rels[1].role).to eq 'scrum_master'
      expect(member_rels[2].dao_person_id).to eq person_c.person_id.to_s
      expect(member_rels[2].role).to eq 'developer'
      expect(member_rels[3].dao_person_id).to eq person_d.person_id.to_s
      expect(member_rels[3].role).to eq 'developer'
    end
  end
end
