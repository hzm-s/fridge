# typed: false
require 'domain_helper'

module Feature
  RSpec.describe Feature do
    let(:product_id) { Product::Id.create }

    describe 'create' do
      it do
        feature = described_class.create(product_id, 'A user story')
        
        aggregate_failures do
          expect(feature.product_id).to eq product_id
          expect(feature.id).to_not be_nil
          expect(feature.description).to eq 'A user story'
        end
      end
    end

    describe 'Acceptance criteria' do
      let(:feature) { described_class.create(product_id, 'A user story') }

      it do
        feature.add_acceptance_criterion(acceptance_criterion('AC1'))
        expect(feature.acceptance_criteria).to eq [acceptance_criterion('AC1')]
      end

      it do
        feature.add_acceptance_criterion(acceptance_criterion('AC1'))
        feature.add_acceptance_criterion(acceptance_criterion('AC2'))
        feature.add_acceptance_criterion(acceptance_criterion('AC3'))

        feature.remove_acceptance_criterion(acceptance_criterion('AC2'))

        expect(feature.acceptance_criteria).to eq [
          acceptance_criterion('AC1'),
          acceptance_criterion('AC3')
        ]
      end
    end
  end
end
