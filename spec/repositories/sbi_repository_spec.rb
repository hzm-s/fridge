# typed: false
require 'rails_helper'

describe SbiRepository::AR do
  let(:product) { create_product }
  let!(:pbi) { add_pbi(product.id, acceptance_criteria: %w(AC1 AC2 AC3)) }

  describe 'Add' do
    it do
      sbi = Sbi::Sbi.plan(pbi.id)

      expect { described_class.store(sbi) }
        .to change { Dao::Sbi.count }.from(0).to(1)
        .and change { Dao::Task.count }.by(0)

      aggregate_failures do
        dao = Dao::Sbi.last
        expect(dao.dao_pbi_id).to eq sbi.pbi_id.to_s
      end
    end
  end

  describe 'Update' do
    it do
      sbi = Sbi::Sbi.plan(pbi.id)
      described_class.store(sbi)

      sbi.update_tasks(tasks(%w(T1 T2 T3)))

      expect { described_class.store(sbi) }
        .to change { Dao::Sbi.count }.by(0)
        .and change { Dao::Task.count }.from(0).to(3)

      dao = Dao::Sbi.last
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
