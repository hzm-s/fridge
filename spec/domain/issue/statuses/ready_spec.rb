# typed: false
require 'domain_helper'

module Issue
  module Statuses
    RSpec.describe Ready do
      describe '#can_remove?' do
        it { expect(described_class).to be_can_remove }
      end

      describe '#can_estimate?' do
        it { expect(described_class).to be_can_estimate }
      end

      describe '#update_by_prepartion' do
        context 'Feature: AcceptanceCriteria >= 1 and size == unknown' do
          it do
            status = described_class.update_by_prepartion(
              Types::Feature,
              acceptance_criteria(%w(AC1)),
              StoryPoint.unknown
            )
            expect(status).to eq Preparation
          end
        end

        context 'Feature: AcceptanceCriteria >= 1 and size != unknown' do
          it do
            status = described_class.update_by_prepartion(
              Types::Feature,
              acceptance_criteria(%w(AC1)),
              StoryPoint.new(3)
            )
            expect(status).to eq Ready
          end
        end

        context 'Feature: AcceptanceCriteria == 0 and size != unknown' do
          it do
            status = described_class.update_by_prepartion(
              Types::Feature,
              acceptance_criteria([]),
              StoryPoint.new(3)
            )
            expect(status).to eq Preparation
          end
        end
      end
    end
  end
end
