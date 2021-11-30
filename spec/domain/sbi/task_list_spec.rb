# typed: false
require 'domain_helper'

module Sbi
  RSpec.describe TaskList do
    describe 'Append and Remove' do
      it do
        list = described_class.new
          .append(s_sentence('Task_A'))
          .remove(1)
          .append(s_sentence('Task_A'))
          .append(s_sentence('Task_B'))
          .append(s_sentence('Task_C'))
          .append(s_sentence('Task_D'))
          .append(s_sentence('Task_E'))
          .remove(4)
          .append(s_sentence('Task_F'))

        aggregate_failures do
          expect(list.of(1).content.to_s).to eq 'Task_A'
          expect(list.of(2).content.to_s).to eq 'Task_B'
          expect(list.of(3).content.to_s).to eq 'Task_C'
          expect(list.of(5).content.to_s).to eq 'Task_E'
          expect(list.of(6).content.to_s).to eq 'Task_F'
        end
      end
    end

    describe 'Modify task' do
      it do
        list = described_class.new
          .append(s_sentence('Task_A'))
          .append(s_sentence('Task_B'))
          .append(s_sentence('Task_C'))
          .modify_content(2, s_sentence('Task_V'))

        aggregate_failures do
          expect(list.of(1).content.to_s).to eq 'Task_A'
          expect(list.of(2).content.to_s).to eq 'Task_V'
          expect(list.of(3).content.to_s).to eq 'Task_C'
        end
      end
    end

    describe 'Update task status' do
      it do
        list = described_class.new
          .append(s_sentence('Task_A'))
          .append(s_sentence('Task_B'))
          .append(s_sentence('Task_C'))
          .append(s_sentence('Task_D'))
          .append(s_sentence('Task_E'))
          .start(1).complete(1)
          .start(2).suspend(2)
          .start(3).suspend(3).resume(3)

        aggregate_failures do
          expect(list.of(1).status.to_s).to eq 'done'
          expect(list.of(2).status.to_s).to eq 'wait'
          expect(list.of(3).status.to_s).to eq 'wip'
          expect(list.of(4).status.to_s).to eq 'todo'
        end
      end
    end
  end
end
