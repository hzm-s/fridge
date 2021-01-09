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
      product = create_product(person: person.id, roles: team_roles(:po))

      team = described_class.call(product.id.to_s, person.id)

      expect(team.roles(person.id.to_s)).to eq [:product_owner]
    end
  end

  context 'when Dev' do
    it do
      product = create_product(person: person.id, roles: team_roles(:dev))

      team = described_class.call(product.id.to_s, person.id)

      expect(team.roles(person.id.to_s)).to eq [:developer]
    end
  end

  context 'when SM' do
    it do
      product = create_product(person: person.id, roles: team_roles(:sm))

      team = described_class.call(product.id.to_s, person.id)

      expect(team.roles(person.id.to_s)).to eq [:scrum_master]
    end
  end

  context 'when SM and Dev' do
    it do
      product = create_product(person: person.id, roles: team_roles(:sm, :dev))

      team = described_class.call(product.id.to_s, person.id)

      expect(team.roles(person.id.to_s)).to eq [:scrum_master, :developer]
    end
  end
end
