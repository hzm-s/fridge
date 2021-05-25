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
        end
      end
    end

    let(:work) { described_class.create(issue_id) }

    describe 'Append task' do
      it do
        work.append_task('Task_A')
        work.append_task('Task_B')
        work.append_task('Task_C')

        aggregate_failures do
          expect(work.task_of(1).content).to eq 'Task_A'
          expect(work.task_of(2).content).to eq 'Task_B'
          expect(work.task_of(3).content).to eq 'Task_C'
        end
      end
    end

    describe 'Remove task' do
      it do
        work.append_task('Task_A')
        work.append_task('Task_B')
        work.append_task('Task_C')

        work.remove_task(1)
        work.remove_task(3)

        expect(work.tasks.map(&:content)).to eq %w(Task_B)
      end
    end
  end
end
