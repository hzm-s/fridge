# typed: false
require 'domain_helper'

module Sbi
  RSpec.describe Sbi do
    let(:pbi_id) { Pbi::Id.create }

    describe 'Plan' do
      it do
        sbi = described_class.plan(pbi_id)

        aggregate_failures do
          expect(sbi.pbi_id).to eq pbi_id
          expect(sbi.tasks).to be_empty
        end
      end
    end

    describe 'Update tasks' do
      let(:sbi) { described_class.plan(pbi_id) }

      it do
        tasks = TaskList.new
          .append(s_sentence('Task_A'))
          .append(s_sentence('Task_B'))
          .append(s_sentence('Task_C'))

        sbi.update_tasks(tasks)

        expect(sbi.tasks).to eq tasks
      end
    end
  end
end
