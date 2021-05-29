# typed: false
require 'domain_helper'

module Team
  class Role
    RSpec.describe ProductOwner do
      describe '#available_activities' do
        it do
          a = described_class.available_activities
          expect(a).to eq activity_set([:remove_issue, :update_plan, :assign_issue_to_sprint, :revert_issue_from_sprint])
        end
      end
    end
  end
end
