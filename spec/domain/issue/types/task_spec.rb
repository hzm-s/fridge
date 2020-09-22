# typed: false
require 'domain_helper'

module Issue::Types
  RSpec.describe Task do
    describe '#can_estimate?' do
      it { expect(described_class).to_not be_can_estimate }
    end
  end
end
