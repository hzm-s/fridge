# typed: false
require 'domain_helper'

module Work
  RSpec.describe Task do
    describe 'Create' do
      it do
        task = described_class.create(1, 'Task_A')

        aggregate_failures do
          expect(task.number).to eq 1
          expect(task.content).to eq 'Task_A'
          expect(task.status.to_s).to eq 'todo'
        end
      end
    end

    describe 'Modify content' do
      it do
        task = described_class.create(1, 'Task_A')
        task.modify('Task_AAA')

        aggregate_failures do
          expect(task.number).to eq 1
          expect(task.content).to eq 'Task_AAA'
        end
      end
    end

    describe 'Update status' do
      let(:task) { described_class.create(1, 'Task') }

      it do
        aggregate_failures do
          expect { task.complete }.to raise_error InvalidTaskStatusUpdate
          expect { task.suspend }.to raise_error InvalidTaskStatusUpdate
          expect { task.resume }.to raise_error InvalidTaskStatusUpdate

          task.start
          expect(task.status.to_s).to eq 'wip'
          expect { task.resume }.to raise_error InvalidTaskStatusUpdate

          task.suspend
          expect(task.status.to_s).to eq 'wait'
          expect { task.start }.to raise_error InvalidTaskStatusUpdate
          expect { task.complete }.to raise_error InvalidTaskStatusUpdate

          task.resume
          expect(task.status.to_s).to eq 'wip'
          expect { task.start }.to raise_error InvalidTaskStatusUpdate

          task.complete
          expect(task.status.to_s).to eq 'done'
          expect { task.start }.to raise_error InvalidTaskStatusUpdate
          expect { task.suspend }.to raise_error InvalidTaskStatusUpdate
          expect { task.resume }.to raise_error InvalidTaskStatusUpdate
        end
      end
    end

    describe 'Query available action' do
      let(:task) { described_class.create(1, 'Task') }

      context 'when todo' do
        it do
          expect(task.available_activities).to eq activity_set([:start_task])
        end
      end

      context 'when wip' do
        before { task.start }

        it do
          expect(task.available_activities).to eq activity_set([:complete_task, :suspend_task])
        end
      end

      context 'when wait' do
        before do
          task.start
          task.suspend
        end

        it do
          expect(task.available_activities).to eq activity_set([:resume_task])
        end
      end

      context 'when done' do
        before do
          task.start
          task.complete
        end

        it do
          expect(task.available_activities).to eq activity_set([])
        end
      end
    end
  end
end
