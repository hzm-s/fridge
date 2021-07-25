# typed: false
require 'domain_helper'

module Issue
  module Statuses
    RSpec.describe Accepted do
      describe '#available_activities' do
        it do
          a = described_class.available_activities
          expect(a).to eq activity_set([])
        end
      end

      describe '#update_by_preparation' do
        it do
          status = described_class.update_by_preparation(
            acceptance_criteria(%w(AC1)),
            StoryPoint.unknown
          )
          expect(status).to eq Accepted
        end
      end

      describe '#assign_to_sprint' do
        it do
          expect { described_class.assign_to_sprint }.to raise_error CanNotAssignToSprint
        end
      end

      describe '#revert_from_sprint' do
        it do
          expect { described_class.revert_from_sprint }.to raise_error CanNotRevertFromSprint
        end
      end

      describe '#update_by_acceptance' do
        context 'some criterion is satisfied' do
          it do
            criteria = acceptance_criteria(%w(AC1 AC2 AC3), [1, 3])
            expect(described_class.update_by_acceptance(criteria)).to eq Wip
          end
        end

        context 'all criteria is satisfied' do
          it do
            criteria = acceptance_criteria(%w(AC1 AC2 AC3), [1, 2, 3])
            expect(described_class.update_by_acceptance(criteria)).to eq Accepted
          end
        end
      end
    end
  end
end
