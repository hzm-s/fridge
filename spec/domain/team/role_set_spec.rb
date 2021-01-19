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

    describe 'query issue estimate permission' do
      it do
        roles = described_class.new([Role::Developer])
        expect(roles).to be_can_estimate_issue
      end

      it do
        roles = described_class.new([Role::ScrumMaster])
        expect(roles).to_not be_can_estimate_issue
      end

      it do
        roles = described_class.new([Role::ProductOwner])
        expect(roles).to_not be_can_estimate_issue
      end

      it do
        roles = described_class.new([Role::ScrumMaster, Role::Developer])
        expect(roles).to be_can_estimate_issue
      end

      it do
        roles = described_class.new([Role::ScrumMaster, Role::ProductOwner])
        expect(roles).to_not be_can_estimate_issue
      end
    end

    describe 'query change issue priority permission' do
      it do
        roles = described_class.new([Role::Developer])
        expect(roles).to_not be_can_change_issue_priority
      end

      it do
        roles = described_class.new([Role::ScrumMaster])
        expect(roles).to be_can_change_issue_priority
      end

      it do
        roles = described_class.new([Role::ProductOwner])
        expect(roles).to be_can_change_issue_priority
      end

      it do
        roles = described_class.new([Role::ScrumMaster, Role::Developer])
        expect(roles).to be_can_change_issue_priority
      end

      it do
        roles = described_class.new([Role::ScrumMaster, Role::ProductOwner])
        expect(roles).to be_can_change_issue_priority
      end
    end
  end
end
