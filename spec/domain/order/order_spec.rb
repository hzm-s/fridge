# typed: false
require 'domain_helper'

module Order
  RSpec.describe Order do
    describe 'create' do
      let!(:product_id) { Product::Id.create }

      it do
        order = described_class.create(product_id)
        expect(order.product_id).to eq product_id
        expect(order.issue_list).to be_empty
      end
    end
  end
end
