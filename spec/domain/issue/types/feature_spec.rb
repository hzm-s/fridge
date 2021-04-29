# typed: false
require 'domain_helper'

module Issue::Types
  RSpec.describe Feature do
    describe '.initial_status' do
      it { expect(described_class.initial_status).to eq ::Issue::Statuses::Preparation }
    end

    describe '.must_have_acceptance_criteria?' do
      it { expect(described_class).to be_must_have_acceptance_criteria }
    end

    describe '.update_by_preparation?' do
      it { expect(described_class).to be_update_by_preparation }
    end
  end
end
