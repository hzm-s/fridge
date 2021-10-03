# typed: false
require 'domain_helper'

module Work
  module Statuses
    RSpec.describe NotAccepted do
      describe '#available_activities' do
        it do
          a = described_class.new(Issue::Types::Feature).available_activities
          expect(a).to eq activity_set([:accept_feature])
        end

        it do
          a = described_class.new(Issue::Types::Task).available_activities
          expect(a).to eq activity_set([:accept_task])
        end
      end
    end
  end
end
