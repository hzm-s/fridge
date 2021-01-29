# typed: false
require 'domain_helper'

module Team
  RSpec.describe Role do
    describe '#can_estimate_issue?' do
      it { expect(Role::ProductOwner).to_not be_can_estimate_issue }
      it { expect(Role::Developer).to be_can_estimate_issue }
      it { expect(Role::ScrumMaster).to_not be_can_estimate_issue }
    end

    describe '#can_update_release_plan?' do
      it { expect(Role::ProductOwner).to be_can_update_release_plan }
      it { expect(Role::Developer).to_not be_can_update_release_plan }
      it { expect(Role::ScrumMaster).to be_can_update_release_plan }
    end
  end
end
