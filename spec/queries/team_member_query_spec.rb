# typed: false
require 'rails_helper'

RSpec.describe TeamMemberQuery do
  let(:person) { sign_up_as_person }

  context 'when PO' do
    before do
      create_product(person: person.id, roles: team_roles(:dev))
    end

    it do
      product = create_product(person: person.id, roles: team_roles(:po))

      member = described_class.call(product.id.to_s, person.id)

      aggregate_failures do
        expect(member.roles).to eq team_roles(:po)
      end
    end
  end

  context 'when Dev' do
    before do
      create_product(person: person.id, roles: team_roles(:po))
    end

    it do
      product = create_product(person: person.id, roles: team_roles(:dev))

      member = described_class.call(product.id.to_s, person.id)

      aggregate_failures do
        expect(member.roles).to eq team_roles(:dev)
      end
    end
  end

  context 'when SM' do
    before do
      create_product(person: person.id, roles: team_roles(:po))
    end

    it do
      product = create_product(person: person.id, roles: team_roles(:sm))

      member = described_class.call(product.id.to_s, person.id)

      aggregate_failures do
        expect(member.roles).to eq team_roles(:sm)
      end
    end
  end

  context 'when SM and Dev' do
    before do
      create_product(person: person.id, roles: team_roles(:sm, :po))
    end

    it do
      product = create_product(person: person.id, roles: team_roles(:sm, :dev))

      member = described_class.call(product.id.to_s, person.id)

      aggregate_failures do
        expect(member.roles).to eq team_roles(:sm, :dev)
      end
    end
  end
end
