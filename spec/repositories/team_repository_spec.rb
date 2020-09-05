# typed: false
require 'rails_helper'

RSpec.describe TeamRepository::AR, type: :repository do
  let(:product) { create_product }
  let(:person_a) { sign_up }
  let(:person_b) { sign_up }
  let(:person_c) { sign_up }

  describe 'add' do
    it do
      team = Team::Team.create('The Team')
      team.develop(product.id)

      team.add_member(sm_member(person_a.person_id))
      team.add_member(dev_member(person_b.person_id))

      described_class.add(team)

      team_rels = Dao::Team.all
      expect(team_rels.size).to eq 1
      expect(team_rels[0].dao_product_id).to eq product.id.to_s
      expect(team_rels[0].name).to eq 'The Team'

      members_rels = Dao::TeamMember.all
      expect(members_rels.size).to eq 2
      expect(members_rels[0].dao_person_id).to eq person_a.person_id.to_s
      expect(members_rels[0].role).to eq 'scrum_master'
      expect(members_rels[1].dao_person_id).to eq person_b.person_id.to_s
      expect(members_rels[1].role).to eq 'developer'
    end
  end

  describe 'update' do
    it do
      team = Team::Team.create('The Team')
      team.develop(product.id)

      team.add_member(sm_member(person_a.person_id))
      team.add_member(dev_member(person_b.person_id))
      described_class.add(team)

      team.add_member(dev_member(person_c.person_id))

      described_class.update(team)

      team_rels = Dao::Team.all
      expect(team_rels.size).to eq 1
      expect(team_rels[0].dao_product_id).to eq product.id.to_s
      expect(team_rels[0].name).to eq 'The Team'

      members_rels = Dao::TeamMember.all
      expect(members_rels.size).to eq 3
      expect(members_rels[0].dao_person_id).to eq person_a.person_id.to_s
      expect(members_rels[0].role).to eq 'scrum_master'
      expect(members_rels[1].dao_person_id).to eq person_b.person_id.to_s
      expect(members_rels[1].role).to eq 'developer'
      expect(members_rels[2].dao_person_id).to eq person_c.person_id.to_s
      expect(members_rels[2].role).to eq 'developer'
    end
  end
end
