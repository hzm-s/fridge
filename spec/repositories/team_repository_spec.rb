# typed: false
require 'rails_helper'

RSpec.describe TeamRepository::AR, type: :repository do
  let(:product) do
    Product::Product
      .create('abc')
      .tap { |p| ProductRepository::AR.store(p) }
  end
  let(:person_a) { sign_up }
  let(:person_b) { sign_up }
  let(:person_c) { sign_up }
  let(:person_d) { sign_up }

  describe 'add' do
    it do
      team = Team::Team.create('The Team')
      team.develop(product.id)
      team.add_member(po_member(person_a.person_id))
      team.add_member(team_member(person_b.person_id, :sm, :dev))
      team.add_member(dev_member(person_c.person_id))

      described_class.store(team)

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
      expect(member_rels[2].dao_person_id).to eq person_b.person_id.to_s
      expect(member_rels[2].role).to eq 'developer'
      expect(member_rels[3].dao_person_id).to eq person_c.person_id.to_s
      expect(member_rels[3].role).to eq 'developer'
    end
  end

  describe 'update' do
    it do
      team = Team::Team.create('The Team')
      team.develop(product.id)
      team.add_member(po_member(person_a.person_id))
      team.add_member(dev_member(person_b.person_id))
      team.add_member(dev_member(person_c.person_id))
      described_class.store(team)

      team.add_member(team_member(person_d.person_id, :sm, :dev))

      described_class.store(team)

      team_rels = Dao::Team.all
      expect(team_rels.size).to eq 1
      expect(team_rels[0].dao_product_id).to eq product.id.to_s
      expect(team_rels[0].name).to eq 'The Team'

      member_rels = Dao::TeamMember.all
      expect(member_rels.size).to eq 5
      expect(member_rels[0].dao_person_id).to eq person_a.person_id.to_s
      expect(member_rels[0].role).to eq 'product_owner'
      expect(member_rels[1].dao_person_id).to eq person_b.person_id.to_s
      expect(member_rels[1].role).to eq 'developer'
      expect(member_rels[2].dao_person_id).to eq person_c.person_id.to_s
      expect(member_rels[2].role).to eq 'developer'
      expect(member_rels[3].dao_person_id).to eq person_d.person_id.to_s
      expect(member_rels[3].role).to eq 'scrum_master'
      expect(member_rels[4].dao_person_id).to eq person_d.person_id.to_s
      expect(member_rels[4].role).to eq 'developer'
    end
  end

  describe 'find' do
    it do
      team = Team::Team.create('The Team')
      team.develop(product.id)
      team.add_member(team_member(person_a.person_id, :po, :sm))
      team.add_member(dev_member(person_b.person_id))
      team.add_member(dev_member(person_c.person_id))
      described_class.store(team)

      found = described_class.find_by_id(team.id)

      aggregate_failures do
        expect(found.members[0]).to eq team_member(person_a.person_id, :po, :sm)
        expect(found.members[1]).to eq dev_member(person_b.person_id)
        expect(found.members[2]).to eq dev_member(person_c.person_id)
      end
    end
  end
end
