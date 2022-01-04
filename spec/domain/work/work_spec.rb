# typed: false
require 'domain_helper'

module Work
  describe Work do
    let(:pbi_id) { Pbi::Id.create }

    describe 'Plan' do
      it do
        work = described_class.plan(pbi_id)

        aggregate_failures do
          expect(work.pbi_id).to eq pbi_id
          expect(work.tasks).to be_empty
        end
      end
    end

    describe 'Update tasks' do
      let(:work) { described_class.plan(pbi_id) }

      it do
        tasks = TaskList.new
          .append(s_sentence('Task_A'))
          .append(s_sentence('Task_B'))
          .append(s_sentence('Task_C'))

        work.update_tasks(tasks)

        expect(work.tasks).to eq tasks
      end
    end
  end
end
