# typed: false
require 'rails_helper'

describe WorkRepository::AR do
  let(:product) { create_product }
  let!(:pbi) { add_pbi(product.id, acceptance_criteria: %w(AC1 AC2 AC3)) }

  xdescribe 'Find or assign' do
    context 'when work is not assigned' do
      it do
        work = described_class.find_or_assign_by_pbi_id(pbi.id)
        expect(work).to_not be_nil
      end
    end
  end

  describe 'Add' do
    it do
      work = Work::Work.assign(pbi.id)

      expect { described_class.store(work) }
        .to change { Dao::Work.count }.from(0).to(1)
        .and change { Dao::Task.count }.by(0)

      aggregate_failures do
        dao = Dao::Work.last
        expect(dao.dao_pbi_id).to eq work.pbi_id.to_s
      end
    end
  end

  describe 'Update' do
    it do
      work = Work::Work.assign(pbi.id)
      described_class.store(work)

      work.update_tasks(tasks(%w(T1 T2 T3)))

      expect { described_class.store(work) }
        .to change { Dao::Work.count }.by(0)
        .and change { Dao::Task.count }.from(0).to(3)

      dao = Dao::Work.last
      aggregate_failures do
        expect(dao.tasks[0].number).to eq 1
        expect(dao.tasks[0].content.to_s).to eq 'T1'
        expect(dao.tasks[0].status).to eq 'todo'
        expect(dao.tasks[1].number).to eq 2
        expect(dao.tasks[1].content.to_s).to eq 'T2'
        expect(dao.tasks[1].status).to eq 'todo'
        expect(dao.tasks[2].number).to eq 3
        expect(dao.tasks[2].content.to_s).to eq 'T3'
        expect(dao.tasks[2].status).to eq 'todo'
      end
    end
  end
end
