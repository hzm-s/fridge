# typed: false
require 'domain_helper'

module Team
  class Role
    RSpec.describe Developer do
      describe '#available_activities' do
        it do
          a = described_class.available_activities
          expect(a).to eq activity_set([
            :prepare_acceptance_criteria,
            :estimate_issue,
            :update_task_acceptance,
          ])
        end
      end
    end
  end
end
