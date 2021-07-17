# typed: false
require 'domain_helper'

module Issue
  RSpec.describe AcceptanceCriterion do
    describe 'Create' do
      it do
        criterion = described_class.create(1, 'Criterion')
        expect(criterion.number).to eq 1
        expect(criterion.content).to eq 'Criterion'
      end
    end
  end
end
