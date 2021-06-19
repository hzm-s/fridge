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

    describe 'Append and Remove task' do
      it do
        work.append_task('Task_A')
        work.remove_task(1)
        work.append_task('Task_A')
        work.append_task('Task_B')
        work.append_task('Task_C')
        work.append_task('Task_D')
        work.append_task('Task_E')
        work.remove_task(4)
        work.append_task('Task_F')

        aggregate_failures do
          expect(work.task_of(1).content).to eq 'Task_A'
          expect(work.task_of(2).content).to eq 'Task_B'
          expect(work.task_of(3).content).to eq 'Task_C'
          expect(work.task_of(5).content).to eq 'Task_E'
          expect(work.task_of(6).content).to eq 'Task_F'
        end
      end
    end

    describe 'Modify task' do
      it do
        work.append_task('Task_A')
        work.append_task('Task_B')
        work.append_task('Task_C')

        work.modify_task(2, 'Task_V')

        aggregate_failures do
          expect(work.task_of(1).content).to eq 'Task_A'
          expect(work.task_of(2).content).to eq 'Task_V'
          expect(work.task_of(3).content).to eq 'Task_C'
        end
      end
    end

    describe 'Update task status' do
      it do
        aggregate_failures do
          work.append_task('Task_A')
          work.append_task('Task_B')

          work.start_task(2)
          expect(work.task_of(1).status.to_s).to eq 'todo'
          expect(work.task_of(2).status.to_s).to eq 'wip'

          work.suspend_task(2)
          expect(work.task_of(1).status.to_s).to eq 'todo'
          expect(work.task_of(2).status.to_s).to eq 'wait'

          work.resume_task(2)
          expect(work.task_of(1).status.to_s).to eq 'todo'
          expect(work.task_of(2).status.to_s).to eq 'wip'

          work.complete_task(2)
          expect(work.task_of(1).status.to_s).to eq 'todo'
          expect(work.task_of(2).status.to_s).to eq 'done'
        end
      end
    end
  end
end
