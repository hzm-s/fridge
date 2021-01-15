# typed: false
require 'domain_helper'

module Issue::Types
  RSpec.describe Task do
    describe '.initial_status' do
      it { expect(described_class.initial_status).to eq ::Issue::Statuses::Ready }
    end

    describe '.can_estimate?' do
      it { expect(described_class).to be_can_estimate }
    end

    describe '.must_have_acceptance_criteria?' do
      it { expect(described_class).to_not be_must_have_acceptance_criteria }
    end

    describe '.update_by_preparation?' do
      it { expect(described_class).to_not be_update_by_preparation }
    end
  end
end
