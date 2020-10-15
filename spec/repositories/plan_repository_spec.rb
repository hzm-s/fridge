# typed: false
require 'rails_helper'

RSpec.describe PlanRepository::AR do
  let(:product) { create_product }

  let(:issue_a) { add_issue(product.id) }
  let(:issue_b) { add_issue(product.id) }
  let(:issue_c) { add_issue(product.id) }

  describe 'Update' do
    it do
      plan = described_class.find_by_product_id(product.id)
      plan.specify_order(Plan::Order.new([issue_a.id, issue_b.id, issue_c.id]))

      expect { described_class.store(plan) }
        .to change { Dao::Order.count }.by(0)

      rel = Dao::Order.find_by(dao_product_id: plan.product_id.to_s)
      expect(rel.entries).to eq [issue_a, issue_b, issue_c].map(&:id).map(&:to_s)
    end
  end

  describe 'Find' do
    it do
      plan = Plan::Plan.create(product.id)
      order = Plan::Order.new([issue_c.id, issue_b.id, issue_a.id])
      plan.specify_order(order)
      described_class.store(plan)

      stored = described_class.find_by_product_id(product.id)

      expect(stored.order).to eq order
    end
  end
end
