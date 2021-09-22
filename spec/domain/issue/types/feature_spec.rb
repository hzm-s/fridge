# typed: false
require 'domain_helper'

module Issue
  module Types
    RSpec.describe Feature do
      describe '.initial_status' do
        it { expect(described_class.initial_status).to eq Statuses::Preparation }
      end

      describe '.prepared?' do
        let(:criteria_any) { acceptance_criteria(%w(CRT)) }
        let(:criteria_empty) { acceptance_criteria([]) }
        let(:size_any) { StoryPoint.new(5) }
        let(:size_unknown) { StoryPoint.unknown }

        context 'cirteira >= 1 and size == unknown' do
          it do
            expect(described_class.prepared?(criteria_any, size_unknown)).to be false
          end
        end

        context 'cirteira >= 1 and size != unknown' do
          it do
            expect(described_class.prepared?(criteria_any, size_any)).to be true
          end
        end

        context 'cirteira == 0 and size != unknown' do
          it do
            expect(described_class.prepared?(criteria_empty, size_any)).to be false
          end
        end

        context 'cirteira == 0 and size == unknown' do
          it do
            expect(described_class.prepared?(criteria_empty, size_unknown)).to be false
          end
        end
      end

      describe '.can_accept?' do
        context 'when accepted' do
          it do
            criteria = acceptance_criteria(%w(AC1 AC2 AC3), :all)
            expect(described_class.can_accept?(true, criteria)).to be false
          end
        end

        context 'when NOT accepted, criteria are satisfied' do
          it do
            criteria = acceptance_criteria(%w(AC1 AC2 AC3), :all)
            expect(described_class.can_accept?(false, criteria)).to be true
          end
        end

        context 'when NOT accepted, criteria are NOT satisfied' do
          it do
            criteria = acceptance_criteria(%w(AC1 AC2 AC3), [1, 3])
            expect(described_class.can_accept?(false, criteria)).to be false
          end
        end
      end

      describe '.must_have_acceptance_criteria?' do
        it { expect(described_class).to be_must_have_acceptance_criteria }
      end

      describe '.accept_issue_activity' do
        it { expect(described_class.accept_issue_activity).to eq :accept_feature }
      end
    end
  end
end
