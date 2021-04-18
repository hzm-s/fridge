# typed: false
require 'domain_helper'

module Activity
  RSpec.describe Set do
    it do
      a = described_class.new([:plan_issue, :remove_issue])
      b = described_class.new([:plan_issue])

      c = a & b

      aggregate_failures do
        expect(c.allow?(:plan_issue)).to be true
        expect(c.allow?(:remove_issue)).to be false
        expect(c.allow?(:update_scheduled_issues)).to be false
      end
    end
  end
end
