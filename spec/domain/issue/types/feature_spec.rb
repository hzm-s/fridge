# typed: false
require 'domain_helper'

module Issue::Types
  RSpec.describe Feature do
    describe '.initial_status' do
      it { expect(described_class.initial_status).to eq ::Issue::Statuses::Preparation }
    end

    describe '.can_estimate?' do
      it { expect(described_class).to be_can_estimate }
    end

    describe '.must_have_acceptance_criteria?' do
      it { expect(described_class).to be_must_have_acceptance_criteria }
    end
  end
end
