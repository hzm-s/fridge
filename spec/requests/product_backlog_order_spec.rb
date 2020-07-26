# typed: false
require 'rails_helper'

RSpec.describe 'product_backlog_order' do
  let!(:user) { sign_up }
  let!(:product) { create_product(user_id: User::Id.from_string(user.id)) }
  let!(:pbi_a) { add_pbi(product.id, 'AAA') }
  let!(:pbi_b) { add_pbi(product.id, 'BBB') }
  let!(:pbi_c) { add_pbi(product.id, 'CCC') }

  describe '#update' do
    it do
      params = {
        pbi_id: pbi_c.id.to_s,
        to: 1
      }
      put product_product_backlog_order_path(product_id: product.id.to_s, format: :json), params: params

      order = ProductBacklogItemOrderRepository::AR.find_by_product_id(product.id)
      expect(order.to_a).to eq [pbi_c, pbi_a, pbi_b].map(&:id)
    end
  end
end
