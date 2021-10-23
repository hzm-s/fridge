# typed: false
require 'domain_helper'

module Issue
  module Statuses
    RSpec.describe Wip do
      describe '.available_activities' do
        it do
          a = described_class.available_activities
          expect(a).to eq activity_set([
            :revert_issue_from_sprint,
            :accept_feature,
            :accept_task,
          ])
        end
      end

      describe '.update_by_preparation' do
        it do
          type = Types::Feature
          criteria = acceptance_criteria(%w(AC1))
          point = StoryPoint.new(3)

          expect { described_class.update_by_preparation(type, criteria, point) }.to raise_error CanNotPrepare
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

      describe '.accept' do
        it do
          expect(described_class.accept).to eq Accepted
        end
      end
    end
  end
end
