# typed: false
require 'domain_helper'

module Activity
  describe Set do
    it do
      a = described_class.new([Activity::RemovePbi, Activity::UpdatePlan])
      b = described_class.new([Activity::UpdatePlan])

      c = a & b

      aggregate_failures do
        expect(c.include?(Activity::RemovePbi)).to be false
        expect(c.include?(Activity::UpdatePlan)).to be true
        expect(c.include?(Activity::EstimatePbi)).to be false
      end
    end
  end
end
