# typed: false
require 'rails_helper'

RSpec.describe WorkRepository::AR do
  let(:product) { create_product }
  let!(:issue) { plan_issue(product.id, acceptance_criteria: %w(AC1 AC2 AC3)) }

  describe 'Add' do
    it do
      work = Work::Work.create(issue)

      expect { described_class.store(work) }
        .to change { Dao::Work.count }.from(0).to(1)
        .and change { Dao::Task.count }.by(0)

      dao = Dao::Work.last
      aggregate_failures do
        expect(dao.dao_issue_id).to eq issue.id.to_s
        expect(dao.status).to eq eq issue.status.to_s
        expect(dao.satisfied_criterion_numbers).to be_empty
      end
    end
  end

  xdescribe 'Update' do
    it do
      work = Work::Work.create(issue)
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

    it do
      work = Work::Work.create(issue)

      work.satisfy_acceptance_criterion(1)
      described_class.store(work)

      work.satisfy_acceptance_criterion(2)
      work.satisfy_acceptance_criterion(3)
      described_class.store(work)

      work.dissatisfy_acceptance_criterion(2)
      described_class.store(work)

      dao = Dao::Work.last
      expect(dao.satisfied_criterion_numbers).to eq [1, 3]
    end
  end
end
