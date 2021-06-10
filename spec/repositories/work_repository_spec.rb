# typed: false
require 'rails_helper'

RSpec.describe WorkRepository::AR do
  let(:product) { create_product }
  let!(:issue) { plan_issue(product.id) }

  describe 'Add' do
    it do
      work = Work::Work.create(issue.id)

      expect { described_class.store(work) }
        .to change { Dao::Work.count }.from(0).to(1)
        .and change { Dao::Task.count }.by(0)

      dao = Dao::Work.last
      expect(dao.dao_issue_id).to eq issue.id.to_s
    end
  end

  describe 'Update' do
    it do
      work = Work::Work.create(issue.id)
      described_class.store(work)

      work.append_task('T1')
      work.append_task('T2')
      work.append_task('T3')

      expect { described_class.store(work) }
        .to change { Dao::Work.count }.by(0)
        .and change { Dao::Task.count }.from(0).to(3)

      dao = Dao::Work.last
      aggregate_failures do
        expect(dao.tasks[0].number).to eq 1
        expect(dao.tasks[0].content).to eq 'T1'
        expect(dao.tasks[0].status).to eq 'ready'
        expect(dao.tasks[1].number).to eq 2
        expect(dao.tasks[1].content).to eq 'T2'
        expect(dao.tasks[1].status).to eq 'ready'
        expect(dao.tasks[2].number).to eq 3
        expect(dao.tasks[2].content).to eq 'T3'
        expect(dao.tasks[2].status).to eq 'ready'
      end
    end
  end
end
