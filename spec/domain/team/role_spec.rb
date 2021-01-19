# typed: false
require 'domain_helper'

module Team
  RSpec.describe Role do
    describe '#can_estimate_issue?' do
      it { expect(Role::ProductOwner).to_not be_can_estimate_issue }
      it { expect(Role::Developer).to be_can_estimate_issue }
      it { expect(Role::ScrumMaster).to_not be_can_estimate_issue }
    end

    xdescribe '#can_change_issue_priority?' do
      it { expect(Role::ProductOwner).to be_can_change_issue_priority }
      it { expect(Role::Developer).to_not be_can_change_issue_priority }
      it { expect(Role::ScrumMaster).to be_can_change_issue_priority }
    end

    context 'when Product Owner' do
      it do
        role = Role::ProductOwner
        expect(role.denied_actions).to match_array [:estimate_size]
        expect(role.to_s).to eq 'product_owner'
      end
    end

    context 'when Developer' do
      it do
        role = Role::Developer
        expect(role.denied_actions).to match_array [:sort]
      end
    end

    context 'when Scrum Master' do
      it do
        role = Role::ScrumMaster
        expect(role.denied_actions).to match_array [:estimate_size]
      end
    end
  end
end
