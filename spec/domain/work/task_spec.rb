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
          expect(task.status).to eq TaskStatus::Ready
        end
      end
    end

    describe 'Modify content' do
      it do
        origin = described_class.create(1, 'Task_A')
        modified = origin.modify('Task_AAA')

        aggregate_failures do
          expect(modified.number).to eq 1
          expect(modified.content).to eq 'Task_AAA'
        end
      end
    end
  end
end
