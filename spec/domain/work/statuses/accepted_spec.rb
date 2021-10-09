# typed: false
require 'domain_helper'

module Work
  module Statuses
    RSpec.describe Accepted do
      let(:issue_type) { Issue::Types::Feature }
      let(:status) { described_class.new(issue_type) }

      describe '#available_activities' do
        it do
          expect(status.available_activities).to eq activity_set([])
        end
      end

      describe '#can_accept?' do
        it { expect(status).to_not be_can_accept }
      end
    end
  end
end
