# typed: false
require 'domain_helper'

module Team
  class Role
    RSpec.describe ProductOwner do
      describe '#available_activities' do
        it do
          a = described_class.available_activities
          expect(a).to eq activity_set([
            :prepare_acceptance_criteria,
            :remove_pbi,
            :update_plan,
            :assign_pbi_to_sprint,
            :revert_pbi_from_sprint,
            :update_sprint_items,
            :update_feature_acceptance,
            :update_task_acceptance,
            :accept_feature,
            :accept_task,
            :mark_pbi_as_done,
          ])
        end
      end
    end
  end
end
