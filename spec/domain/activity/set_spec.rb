# typed: false
require 'domain_helper'

module Activity
  RSpec.describe Set do
    it do
      a = described_class.new([Activity::RemoveIssue, Activity::UpdatePlan])
      b = described_class.new([Activity::UpdatePlan])

      c = a & b

      aggregate_failures do
        expect(c.allow?(Activity::RemoveIssue)).to be false
        expect(c.allow?(Activity::UpdatePlan)).to be true
        expect(c.allow?(Activity::EstimateIssue)).to be false
      end
    end
  end
end
