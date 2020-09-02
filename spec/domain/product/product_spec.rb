# typed: false
require 'domain_helper'

module Product
  RSpec.describe Product do
    describe 'Create product' do
      it do
        product = described_class.create('ABC', 'DESC_ABC')

        aggregate_failures do
          expect(product.id).to_not be_nil
          expect(product.name).to eq 'ABC'
          expect(product.description).to eq 'DESC_ABC'
          expect(product.teams).to be_empty
        end
      end
    end

    describe 'Assign team' do
      it do
        team = Team::Id.create
        product = described_class.create('ABC')

        product.assign_team(team)

        expect(product.teams).to eq [team]
      end
    end
  end
end
