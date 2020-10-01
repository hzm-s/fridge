# typed: false
require 'rails_helper'

RSpec.describe OrderRepository::AR do
  let(:product) { create_product }

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
end
