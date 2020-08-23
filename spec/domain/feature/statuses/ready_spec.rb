# typed: false
require 'domain_helper'

module Feature
  module Statuses
    RSpec.describe Ready do
      describe '#can_start_development?' do
        it { expect(described_class).to be_can_start_development }
      end

      describe '#can_abort_development?' do
        it { expect(described_class).to_not be_can_abort_development }
      end

      describe '#can_remove?' do
        it { expect(described_class).to be_can_remove }
      end

      describe '#can_estimate?' do
        it { expect(described_class).to be_can_estimate }
      end

      describe '#update_by_prepartion' do
        context 'AcceptanceCriteria >= 1 and size == unknown' do
          it do
            status = described_class.update_by_prepartion(
              acceptance_criteria(%w(AC1)),
              StoryPoint.unknown
            )
            expect(status).to eq Preparation
          end
        end

        context 'AcceptanceCriteria >= 1 and size != unknown' do
          it do
            status = described_class.update_by_prepartion(
              acceptance_criteria(%w(AC1)),
              StoryPoint.new(3)
            )
            expect(status).to eq Ready
          end
        end

        context 'AcceptanceCriteria == 0 and size != unknown' do
          it do
            status = described_class.update_by_prepartion(
              acceptance_criteria([]),
              StoryPoint.new(3)
            )
            expect(status).to eq Preparation
          end
        end
      end

      describe '#update_to_wip' do
        it do
          status = described_class.update_to_wip
          expect(status).to eq Wip
        end
      end

      describe '#update_by_abort_development' do
        it do
          expect { described_class.update_by_abort_development }
            .to raise_error NotDevelopmentStarted
        end
      end
    end
  end
end
