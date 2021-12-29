# typed: false
require 'domain_helper'

module Team
  class Role
    describe Developer do
      describe '#available_activities' do
        it do
          a = described_class.available_activities
          expect(a).to eq activity_set([
            :prepare_acceptance_criteria,
            :estimate_pbi,
            :update_task_acceptance,
            :accept_task,
          ])
        end
      end
    end
  end
end
