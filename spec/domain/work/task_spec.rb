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

    describe 'Start' do
      it do
        task = described_class.create(1, 'Task')
        task.start

        expect(task.status.to_s).to eq 'wip'
      end
    end
  end
end
