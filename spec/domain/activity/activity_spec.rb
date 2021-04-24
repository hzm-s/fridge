# typed: false
require 'domain_helper'

module Activity
  RSpec.describe Activity do
    it do
      r = Activity::EstimateIssue.allow?([
        Set.from_symbols([:estimate_issue]),
        Set.from_symbols([:estimate_issue, :remove_issue]),
      ])
      expect(r).to be true
    end

    it do
      r = Activity::EstimateIssue.allow?([
        Set.from_symbols([:update_plan]),
        Set.from_symbols([:estimate_issue, :remove_issue]),
      ])
      expect(r).to be false
    end
  end
end
