# typed: false
require 'rails_helper'

RSpec.describe PlanRepository::AR do
  let(:product) { create_product }

  let(:issue_a) { add_issue(product.id) }
  let(:issue_b) { add_issue(product.id) }
  let(:issue_c) { add_issue(product.id) }

  describe 'Update' do
    it do
      order = described_class.find_by_product_id(product.id)
      order.append_issue(issue_a.id)
      order.append_issue(issue_b.id)
      order.append_issue(issue_c.id)

      expect { described_class.store(order) }
        .to change { Dao::Order.count }.by(0)

      rel = Dao::Order.find_by(dao_product_id: order.product_id.to_s)
      expect(rel.entries).to eq [issue_a, issue_b, issue_c].map(&:id).map(&:to_s)
    end
  end

  describe 'Find' do
    it do
      order = Plan::Plan.create(product.id)
      order.append_issue(issue_a.id)
      order.append_issue(issue_b.id)
      order.append_issue(issue_c.id)
      described_class.store(order)

      stored = described_class.find_by_product_id(product.id)

      expect(stored.order).to eq Plan::Order.new([issue_a.id, issue_b.id, issue_c.id])
    end
  end
end
