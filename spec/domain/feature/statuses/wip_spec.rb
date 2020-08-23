# typed: false
require 'domain_helper'

module Feature
  module Statuses
    RSpec.describe Wip do
      describe '#can_start_development?' do
        it { expect(described_class).to_not be_can_start_development }
      end

      describe '#can_cancel_assignment?' do
        it { expect(described_class).to be_can_cancel_assignment }
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
            .to raise_error AssignProductBacklogItemNotAllowed
        end
      end

      describe '#update_by_cancel_assignment' do
        it do
          status = described_class.update_by_cancel_assignment
          expect(status).to eq Ready
        end
      end
    end
  end
end
