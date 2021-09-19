# typed: false
require 'domain_helper'

module Issue
  module Statuses
    RSpec.describe Accepted do
      describe '.available_activities' do
        it do
          a = described_class.available_activities
          expect(a).to eq activity_set([:revert_issue_from_sprint])
        end
      end

      describe '.update_by_preparation' do
        it do
          expect {
            described_class.update_by_preparation(
              Types::Feature,
              acceptance_criteria(%w(AC1)),
              StoryPoint.new(3)
            )
          }.to raise_error CanNotPrepare
        end
      end

      describe '.assign_to_sprint' do
        it do
          expect { described_class.assign_to_sprint }.to raise_error CanNotAssignToSprint
        end
      end

      describe '.revert_from_sprint' do
        it do
          expect(described_class.revert_from_sprint).to eq Ready
        end
      end

      describe '.update_by_acceptance' do
        it do
          criteria = acceptance_criteria(%w(CRT))
          expect(described_class.update_by_acceptance(Types::Feature, criteria)).to eq Accepted
        end
      end
    end
  end
end
