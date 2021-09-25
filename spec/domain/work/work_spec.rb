# typed: false
require 'domain_helper'

module Work
  RSpec.describe Work do
    let(:issue_id) { Issue::Id.create }
    let(:criteria) { acceptance_criteria(%w(CRT)) }

    describe 'Create' do
      it do
        work = described_class.create(issue_id, Issue::Types::Feature, criteria)

        aggregate_failures do
          expect(work.issue_id).to eq issue_id
          expect(work.acceptance.status).to eq Status::NotAccepted
          expect(work.tasks).to be_empty
        end
      end
    end

    describe 'Update tasks' do
      let(:work) { described_class.create(issue_id, Issue::Types::Feature, criteria) }

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
      let(:work) { described_class.create(issue_id, Issue::Types::Feature, acceptance_criteria(%w(CRT))) }

      it do
        aggregate_failures do
          work.satisfy_acceptance_criterion(1)
          expect(work.acceptance.status).to eq Status::Acceptable

          work.dissatisfy_acceptance_criterion(1)
          expect(work.acceptance.status).to eq Status::NotAccepted
        end
      end
    end
  end
end
