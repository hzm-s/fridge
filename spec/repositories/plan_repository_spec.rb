# typed: false
require 'rails_helper'

RSpec.describe PlanRepository::AR do
  let(:product_id) { Product::Id.create }
  let!(:issue_a) { Issue::Id.create }
  let!(:issue_b) { Issue::Id.create }
  let!(:issue_c) { Issue::Id.create }

  before do
    Dao::Product.create!(id: product_id.to_s, name: 'p')
  end

  describe 'Append' do
    it do
      plan = Plan::Plan.create(product_id)
      plan.release_of(1).tap do |r|
        r.append_issue(issue_a)
        r.append_issue(issue_b)
        r.append_issue(issue_c)
        plan.update_release(r)
      end

      expect { described_class.store(plan) }
        .to change { Dao::Release.count }.by(1)

      stored = described_class.find_by_product_id(product_id)

      aggregate_failures do
        expect(stored.release_of(1).issues).to eq issue_list(issue_a, issue_b, issue_c)
      end
    end
  end

  xdescribe 'Update' do
    it do
      release = Release::Release.create(product_id, 1)
      described_class.store(release)

      release.append_issue(issue_b)
      release.append_issue(issue_c)
      release.append_issue(issue_a)

      expect { described_class.store(release) }
        .to change { Dao::Release.count }.by(0)

      stored = Dao::Release.last

      expect(stored.dao_product_id).to eq product_id.to_s
      expect(stored.number).to eq 1
      expect(stored.issues).to eq [issue_b, issue_c, issue_a].map(&:to_s)
    end
  end

  describe 'Remove'
end
