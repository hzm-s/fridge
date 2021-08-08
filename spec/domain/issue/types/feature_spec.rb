# typed: false
require 'domain_helper'

module Issue::Types
  RSpec.describe Feature do
    describe '.initial_status' do
      it { expect(described_class.initial_status).to eq ::Issue::Statuses::Preparation }
    end

    describe '.can_accept?' do
      context 'when criteria are satisfied' do
        it do
          criteria = acceptance_criteria(%w(AC1 AC2 AC3), :all)
          expect(described_class.can_accept?(criteria)).to be true
        end
      end

      context 'when criteria are NOT satisfied' do
        it do
          criteria = acceptance_criteria(%w(AC1 AC2 AC3), [1, 3])
          expect(described_class.can_accept?(criteria)).to be false
        end
      end
    end

    describe '.must_have_acceptance_criteria?' do
      it { expect(described_class).to be_must_have_acceptance_criteria }
    end

    describe '.update_by_preparation?' do
      it { expect(described_class).to be_update_by_preparation }
    end

    describe '.accept_issue_activity' do
      it { expect(described_class.accept_issue_activity).to eq :accept_feature }
    end
  end
end
