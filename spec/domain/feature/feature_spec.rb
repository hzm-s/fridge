# typed: false
require 'domain_helper'

module Feature
  RSpec.describe Feature do
    it do
      feature = described_class.create('A user story')
      
      aggregate_failures do
        expect(feature.id).to_not be_nil
        expect(feature.description).to eq 'A user story'
      end
    end

    describe 'Acceptance criteria' do
      it do
        feature = described_class.create('A user story')

        feature.add_acceptance_criterion(_acceptance_criterion('AC1'))

        expect(feature.acceptance_criteria).to eq [_acceptance_criterion('AC1')]
      end

      it do
        feature = described_class.create('A user story')
        feature.add_acceptance_criterion(_acceptance_criterion('AC1'))
        feature.add_acceptance_criterion(_acceptance_criterion('AC2'))
        feature.add_acceptance_criterion(_acceptance_criterion('AC3'))

        feature.remove_acceptance_criterion(_acceptance_criterion('AC2'))

        expect(feature.acceptance_criteria).to eq [
          _acceptance_criterion('AC1'),
          _acceptance_criterion('AC3')
        ]
      end
    end
  end
end
