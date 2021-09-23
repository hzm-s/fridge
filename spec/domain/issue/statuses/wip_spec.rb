# typed: false
require 'domain_helper'

module Issue
  module Statuses
    RSpec.describe Wip do
      let(:status) do
        described_class.new
      end

      describe '#available_activities' do
        it do
          a = status.available_activities
          expect(a).to eq activity_set([
            :revert_issue_from_sprint,
            :accept_feature,
            :accept_task,
          ])
        end
      end

      describe '#update_by_preparation' do
        context 'prepared = true' do
          it do
            new_status = status.update_by_preparation(
              Types::Feature,
              acceptance_criteria(%w(AC1)),
              StoryPoint.new(3)
            )
            expect(new_status).to eq status
          end
        end

        context 'prepared = false' do
          it do
            new_status = status.update_by_preparation(
              Types::Feature,
              acceptance_criteria(%w(AC1)),
              StoryPoint.unknown
            )
            expect(new_status).to eq status
          end
        end
      end

      describe '#assign_to_sprint' do
        it do
          expect { status.assign_to_sprint }.to raise_error CanNotAssignToSprint
        end
      end

      describe '#revert_from_sprint' do
        it do
          expect(status.revert_from_sprint).to eq Ready
        end
      end
    end
  end
end
