# typed: false
require 'domain_helper'

module Issue::Types
  RSpec.describe Feature do
    describe '#can_estimate?' do
      it { expect(described_class).to be_can_estimate }
    end
  end
end
