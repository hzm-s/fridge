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
        expect(stored.releases.size).to eq 1
        expect(stored.release_of(1).issues).to eq issue_list(issue_a, issue_b, issue_c)
      end
    end
  end

  describe 'Update' do
    it do
      plan = Plan::Plan.create(product_id)
      plan.release_of(1).tap do |r|
        r.append_issue(issue_b)
        plan.update_release(r)
      end
      described_class.store(plan)

      plan.append_release
      plan.release_of(2).tap do |r|
        r.append_issue(issue_c)
        r.append_issue(issue_a)
        plan.update_release(r)
      end

      expect { described_class.store(plan) }
        .to change { Dao::Release.count }.from(1).to(2)

      stored = described_class.find_by_product_id(product_id)

      aggregate_failures do
        expect(stored.releases.size).to eq 2
        expect(stored.release_of(1).issues).to eq issue_list(issue_b)
        expect(stored.release_of(2).issues).to eq issue_list(issue_c, issue_a)
      end
    end
  end

  describe 'Remove' do
  end
end
