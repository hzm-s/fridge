# typed: false
require 'domain_helper'

module Issue
  module Statuses
    RSpec.describe Wip do
      describe '#available_activities' do
        it do
          a = described_class.available_activities
          expect(a).to eq activity_set([])
        end
      end

      describe '#assign_to_sprint' do
        it do
          expect { described_class.assign_to_sprint }.to raise_error CanNotAssignToSprint
        end
      end
    end
  end
end
