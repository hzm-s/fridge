# typed: false
require 'domain_helper'

module Work
  describe Task do
    describe 'Create' do
      it do
        task = described_class.create(1, s_sentence('Task_A'))

        aggregate_failures do
          expect(task.number).to eq 1
          expect(task.content.to_s).to eq 'Task_A'
          expect(task.status.to_s).to eq 'todo'
        end
      end
    end

    describe 'Modify content' do
      it do
        task = described_class.create(1, s_sentence('Task_A'))
        task.modify(s_sentence('Task_AAA'))

        aggregate_failures do
          expect(task.number).to eq 1
          expect(task.content.to_s).to eq 'Task_AAA'
        end
      end
    end

    describe 'Update status' do
      let(:task) { described_class.create(1, s_sentence('Task')) }

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
  end
end
