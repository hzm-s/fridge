# typed: false
require 'domain_helper'

module Work
  module Statuses
    RSpec.describe Acceptable do
      let(:feature) { described_class.new(Issue::Types::Feature) }
      let(:task) { described_class.new(Issue::Types::Task) }

      describe '#available_activities' do
        it do
          expect(feature.available_activities).to eq activity_set([:accept_feature])
        end

        it do
          expect(task.available_activities).to eq activity_set([:accept_task])
        end
      end

      describe '#update_by_acceptance' do
        let(:criteria) { acceptance_criteria(%w(CRT)) }
        let(:all_satisfied) { Acceptance.new(criteria, [1].to_set) }
        let(:not_all_satisfied) { Acceptance.new(criteria, [].to_set) }

        context 'all_satisfied = yes' do
          it do
            expect(feature.update_by_acceptance(all_satisfied)).to eq feature
          end
        end

        context 'all_satisfied = no' do
          it do
            expect(feature.update_by_acceptance(not_all_satisfied)).to eq NotAccepted.new(feature.issue_type)
          end
        end
      end
    end
  end
end
