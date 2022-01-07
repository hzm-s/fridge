# typed: false
require 'domain_helper'

module Work
  describe Work do
    let(:pbi_id) { Pbi::Id.create }
    let(:sprint_id) { Sprint::Id.create }

    describe 'Assign' do
      it do
        work = described_class.assign(pbi_id, sprint_id)

        aggregate_failures do
          expect(work.pbi_id).to eq pbi_id
          expect(work.sprint_id).to eq sprint_id
          expect(work.status).to eq Statuses.from_string('assigned')
          expect(work.tasks).to be_empty
        end
      end
    end

    describe 'Update tasks' do
      let(:work) { described_class.assign(pbi_id, sprint_id) }

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
