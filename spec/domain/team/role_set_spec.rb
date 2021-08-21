# typed: false
require 'domain_helper'

module Team
  RSpec.describe RoleSet do
    describe 'create' do
      it do
        expect { described_class.new([Role::Developer]) }
          .to_not raise_error
      end

      it do
        expect { described_class.new([Role::ScrumMaster, Role::Developer]) }
          .to_not raise_error
      end

      it do
        expect { described_class.new([Role::ScrumMaster, Role::ProductOwner]) }
          .to_not raise_error
      end

      it do
        expect { described_class.new([Role::ProductOwner, Role::Developer]) }
          .to raise_error InvalidMultipleRoles
      end

      it do
        expect { described_class.new([Role::ProductOwner, Role::ScrumMaster, Role::Developer]) }
          .to raise_error MemberHasTooManyRoles
      end
    end

    describe 'query avilable activities' do
      it do
        roles = described_class.new([Role::Developer])
        expect(roles.available_activities).to eq activity_set([
          :prepare_acceptance_criteria,
          :estimate_issue,
          :update_task,
          :accept_task,
        ])
      end

      it do
        roles = described_class.new([Role::ScrumMaster, Role::ProductOwner])
        expect(roles.available_activities).to eq activity_set([
          :prepare_acceptance_criteria,
          :remove_issue,
          :update_plan,
          :assign_issue_to_sprint,
          :revert_issue_from_sprint,
          :update_sprint_issues,
          :update_task,
          :accept_feature,
          :accept_task,
          :mark_issue_as_done,
        ])
      end
    end
  end
end
