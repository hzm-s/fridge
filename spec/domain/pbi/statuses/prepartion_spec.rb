# typed: false
require 'rails_helper'

module Pbi
  module Statuses
    RSpec.describe Preparation do
      describe '#can_assign?' do
        it do
          expect(described_class).to_not be_can_assign
        end
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
    end
  end
end
