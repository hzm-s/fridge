# typed: false
require 'domain_helper'

module Work
  RSpec.describe Work do
    let(:issue_id) { Issue::Id.create }

    describe 'Create' do
      it do
        work = described_class.create(issue_id)

        aggregate_failures do
          expect(work.issue_id).to eq issue_id
          expect(work.tasks).to be_empty
          expect(work.status).to eq Status::NotAccepted
        end
      end
    end

    let(:work) { described_class.create(issue_id) }

    describe 'Update tasks' do
      it do
        tasks = TaskList.new
          .append(s_sentence('Task_1'))
          .append(s_sentence('Task_2'))
          .append(s_sentence('Task_3'))

        work.update_tasks(tasks)

        expect(work.tasks).to eq tasks
      end
    end

    describe 'Status' do
      it do
        criteria = acceptance_criteria(%w(AC1 AC2 AC3))

        aggregate_failures do
          expect { work.satisfy_acceptance_criterion(criteria, 4) }.to raise_error AcceptanceCriterionNotFound
          expect { work.dissatisfy_acceptance_criterion(criteria, 1) }.to raise_error NotSatisfied

          work.satisfy_acceptance_criterion(criteria, 1)
          expect(work.satisfied_acceptance_criteria).to eq [1].to_set
          expect(work.status).to eq Status::NotAccepted

          expect { work.satisfy_acceptance_criterion(criteria, 1) }.to raise_error AlreadySatisfied

          work.satisfy_acceptance_criterion(criteria, 2)
          work.satisfy_acceptance_criterion(criteria, 3)
          expect(work.satisfied_acceptance_criteria).to eq [1, 2, 3].to_set
          expect(work.status).to eq Status::Acceptable

        end
      end
    end
  end
end
