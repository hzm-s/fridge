# typed: false
require 'rails_helper'

RSpec.describe ProductTeamQuery do
  let(:person) { sign_up_as_person }

  let!(:other_product_team) do
    create_product(members: [
      dev_member(sign_up_as_person.id),
      dev_member(sign_up_as_person.id),
      sm_member(sign_up_as_person.id),
    ])
  end

  context 'when PO' do
    it do
      product = create_product(person: person.id, role: Team::Role::ProductOwner)

      team = described_class.call(product.id.to_s, person.id)

      expect(team.role(person.id.to_s).to_a).to eq [:product_owner]
    end
  end

  context 'when Dev' do
    it do
      product = create_product(person: person.id, role: Team::Role::Developer)

      team = described_class.call(product.id.to_s, person.id)

      expect(team.role(person.id.to_s).to_a).to eq [:developer]
    end
  end

  context 'when SM' do
    it do
      product = create_product(person: person.id, role: Team::Role::ScrumMaster)

      team = described_class.call(product.id.to_s, person.id)

      expect(team.role(person.id.to_s).to_a).to eq [:scrum_master]
    end
  end

  xcontext 'when PO and Dev' do
    it do
      product = create_product(owner: person.id, members: [dev_member(person.id)])

      team = described_class.call(person.id, product.id.to_s)

      expect(team.role(person.id.to_s).to_a).to eq [:product_owner, :developer]
    end
  end
end
