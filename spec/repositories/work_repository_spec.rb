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
end
