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
          expect { task.complete }.to raise_error TaskIsNotStarted

          task.start
          expect(task.status.to_s).to eq 'wip'

          task.complete
          expect(task.status.to_s).to eq 'done'
          expect { task.start }.to raise_error TaskIsDone
        end
      end
    end

    describe 'Query available action' do
      xit {}
    end
  end
end
