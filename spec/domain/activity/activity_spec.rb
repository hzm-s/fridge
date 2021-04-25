# typed: false
require 'domain_helper'

module Activity
  RSpec.describe Activity do
    it do
      r = Activity::EstimateIssue.allow?([
        Issue::Statuses::Preparation,
        Team::RoleSet.new([Team::Role::Developer]),
      ])
      expect(r).to be true
    end

    it do
      r = Activity::EstimateIssue.allow?([
        Issue::Statuses::Preparation,
        Team::RoleSet.new([Team::Role::ProductOwner, Team::Role::ScrumMaster]),
      ])
      expect(r).to be false
    end
  end
end
