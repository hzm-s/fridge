# typed: false
require 'domain_helper'

module Team
  class Role
    RSpec.describe Developer do
      describe '#available_activities' do
        it do
          a = described_class.available_activities
          expect(a).to eq activity_set([:estimate_issue])
        end
      end
    end
  end
end
