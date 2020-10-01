# typed: false
require 'rails_helper'

RSpec.describe OrderRepository::AR do
  let(:product) { create_product }

  let(:issue_a) { add_issue(product.id) }
  let(:issue_b) { add_issue(product.id) }
  let(:issue_c) { add_issue(product.id) }

  describe 'Add' do
    it do
      order = Order::Order.create(product.id)

      expect { described_class.store(order) }
        .to change { Dao::Order.count }.by(1)

      aggregate_failures do
        rel = Dao::Order.last
        expect(rel.dao_product_id).to eq product.id.to_s
        expect(rel.entries).to be_empty
      end
    end
  end

  describe 'Update' do
    it do
      order = Order::Order.create(product.id)
      described_class.store(order)

      order.append_issue(issue_a.id)
      order.append_issue(issue_b.id)
      order.append_issue(issue_c.id)

      expect { described_class.store(order) }
        .to change { Dao::Order.count }.by(0)

      rel = Dao::Order.find_by(dao_product_id: order.product_id.to_s)
      expect(rel.entries).to eq [issue_a, issue_b, issue_c].map(&:id).map(&:to_s)
    end
  end
end
