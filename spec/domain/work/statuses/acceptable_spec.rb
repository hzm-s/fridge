# typed: false
require 'domain_helper'

module Work
  module Statuses
    RSpec.describe Acceptable do
      let(:issue_type) { Issue::Types::Feature }
      let(:status) { described_class.new(issue_type) }

      describe '#available_activities' do
        it do
          expect(status.available_activities).to eq Activity::Set.new([issue_type.acceptance_activity])
        end
      end

      describe '#update_by_acceptance' do
        let(:criteria) { acceptance_criteria(%w(CRT)) }
        let(:all_satisfied) { Acceptance.new(criteria, [1].to_set) }
        let(:not_all_satisfied) { Acceptance.new(criteria, [].to_set) }

        context 'all_satisfied = yes' do
          it do
            expect(status.update_by_acceptance(all_satisfied)).to eq status
          end
        end

        context 'all_satisfied = no' do
          it do
            expect(status.update_by_acceptance(not_all_satisfied)).to eq NotAccepted.new(issue_type)
          end
        end
      end

      describe '#can_accept?' do
        it { expect(status).to be_can_accept }
      end
    end
  end
end
