# typed: false
require 'domain_helper'

module Work
  module Statuses
    RSpec.describe Accepted do
      describe '#available_activities' do
        it do
          expect(described_class.available_activities).to eq activity_set([])
        end
      end

      describe '.accept' do
        it { expect(described_class.accept).to eq described_class }
      end

      describe '#can_accept?' do
        it { expect(described_class).to_not be_can_accept }
      end
    end
  end
end
