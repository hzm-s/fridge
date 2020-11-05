# typed: false
require 'rails_helper'

RSpec.describe PlanRepository::AR do
  let(:product) { create_product }

  let(:issue_a) { add_issue(product.id) }
  let(:issue_b) { add_issue(product.id) }
  let(:issue_c) { add_issue(product.id) }

  describe 'Store' do
    it do
      plan = described_class.find_by_product_id(product.id)
      plan.append_issue(issue_a.id)
      plan.append_issue(issue_b.id)
      plan.append_issue(issue_c.id)
      plan.specify_release('Ph1', issue_a.id)
      plan.specify_release('Ph2', issue_c.id)

      expect { described_class.store(plan) }
        .to change { Dao::Order.count }.by(0)
        .and change { Dao::Scope.count }.by(2)

      rel_order = Dao::Order.find_by(dao_product_id: plan.product_id.to_s)
      expect(rel_order.entries).to eq [issue_a, issue_b, issue_c].map(&:id).map(&:to_s)

      rel_scopes = Dao::Scope.where(dao_product_id: plan.product_id.to_s)
      expect(rel_scopes.size).to eq 2
      expect(rel_scopes[0].release_id).to eq 'Ph1'
      expect(rel_scopes[0].tail).to eq issue_a.id.to_s
      expect(rel_scopes[1].release_id).to eq 'Ph2'
      expect(rel_scopes[1].tail).to eq issue_c.id.to_s
    end
  end

  xdescribe 'Find' do
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
