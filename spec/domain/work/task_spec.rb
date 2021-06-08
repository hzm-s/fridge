# typed: false
require 'domain_helper'

module Work
  RSpec.describe Task do
    describe 'Create' do
      it do
        task = described_class.new(1, 'Task_A')

        aggregate_failures do
          expect(task.number).to eq 1
          expect(task.content).to eq 'Task_A'
        end
      end
    end

    describe 'Modify content' do
      it do
        origin = described_class.new(1, 'Task_A')
        modified = origin.modify('Task_AAA')

        aggregate_failures do
          expect(modified.number).to eq 1
          expect(modified.content).to eq 'Task_AAA'
        end
      end
    end
  end
end
