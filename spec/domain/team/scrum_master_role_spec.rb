# typed: false
require 'domain_helper'

module Team
  class Role
    describe ScrumMaster do
      describe '#available_activities' do
        it do
          a = described_class.available_activities
          expect(a).to eq activity_set([
            :prepare_acceptance_criteria,
            :remove_pbi,
            :update_roadmap,
            :assign_pbi_to_sprint,
            :revert_pbi_from_sprint,
            :update_sprint_items,
          ])
        end
      end
    end
  end
end
