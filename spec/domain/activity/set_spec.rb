# typed: false
require 'domain_helper'

module Activity
  describe Set do
    it do
      a = described_class.new([Activity::RemovePbi, Activity::UpdateRoadmap])
      b = described_class.new([Activity::UpdateRoadmap])

      c = a & b

      aggregate_failures do
        expect(c.include?(Activity::RemovePbi)).to be false
        expect(c.include?(Activity::UpdateRoadmap)).to be true
        expect(c.include?(Activity::EstimatePbi)).to be false
      end
    end
  end
end
