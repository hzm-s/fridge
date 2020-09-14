# typed: false
require 'domain_helper'

module Issue
  module Statuses
    RSpec.describe Wip do
      describe '#can_start_development?' do
        it { expect(described_class).to_not be_can_start_development }
      end

      describe '#can_abort_development?' do
        it { expect(described_class).to be_can_abort_development }
      end

      describe '#can_remove?' do
        it { expect(described_class).to_not be_can_remove }
      end

      describe '#can_estimate?' do
        it { expect(described_class).to_not be_can_estimate }
      end

      describe '#update_to_wip' do
        it do
          expect { described_class.update_to_wip }
            .to raise_error CanNotStartDevelopment
        end
      end

      describe '#update_by_abort_development' do
        it do
          status = described_class.update_by_abort_development
          expect(status).to eq Ready
        end
      end
    end
  end
end
