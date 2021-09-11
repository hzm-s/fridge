# typed: false
require 'domain_helper'

module Issue
  RSpec.describe AcceptanceCriterion do
    describe 'Create' do
      it do
        criterion = described_class.create(1, s_sentence('Criterion'))
        expect(criterion.number).to eq 1
        expect(criterion.content.to_s).to eq 'Criterion'
        expect(criterion).to_not be_satisfied
      end
    end

    describe 'Satisfy and Dissatisfy' do
      it do
        criterion = described_class.create(1, s_sentence('Criteiron'))
        criterion.satisfy
        expect(criterion).to be_satisfied

        criterion.satisfy
        expect(criterion).to be_satisfied

        criterion.dissatisfy
        expect(criterion).to_not be_satisfied

        criterion.dissatisfy
        expect(criterion).to_not be_satisfied
      end
    end
  end
end
