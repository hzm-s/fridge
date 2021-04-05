# typed: false
require 'domain_helper'

module Issue
  module Statuses
    RSpec.describe Wip do
      describe '#can_remove?' do
        it { expect(described_class).to_not be_can_remove }
      end

      describe '#can_estimate?' do
        it { expect(described_class).to_not be_can_estimate }
      end

      describe '#assign_to_sprint' do
        it do
          expect { described_class.assign_to_sprint }.to raise_error CanNotAssignToSprint
        end
      end
    end
  end
end
