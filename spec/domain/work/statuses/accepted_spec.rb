# typed: false
require 'domain_helper'

module Work
  module Statuses
    RSpec.describe Accepted do
      let(:feature) { described_class.new(Issue::Types::Feature) }
      let(:task) { described_class.new(Issue::Types::Task) }

      describe '#available_activities' do
        it do
          expect(feature.available_activities).to eq activity_set([])
        end

        it do
          expect(task.available_activities).to eq activity_set([])
        end
      end
    end
  end
end
