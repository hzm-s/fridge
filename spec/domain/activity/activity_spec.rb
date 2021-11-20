# typed: false
require 'domain_helper'

module Activity
  RSpec.describe Activity do
    it do
      r = Activity::EstimatePbi.allow?([
        Pbi::Statuses.from_string('preparation'),
        Team::RoleSet.new([Team::Role::Developer]),
      ])
      expect(r).to be true
    end

    it do
      r = Activity::EstimatePbi.allow?([
        Pbi::Statuses.from_string('preparation'),
        Team::RoleSet.new([Team::Role::ProductOwner, Team::Role::ScrumMaster]),
      ])
      expect(r).to be false
    end
  end
end
