require 'rails_helper'

RSpec.describe 'product_backlog_order' do
  let!(:product) { create_product }
  let!(:pbi_a) { add_pbi(product.id, 'AAA') }
  let!(:pbi_b) { add_pbi(product.id, 'BBB') }
  let!(:pbi_c) { add_pbi(product.id, 'CCC') }

  describe '#update' do
    it do
      params = {
        src: pbi_c.id.to_s,
        dst: pbi_a.id.to_s
      }
      put product_product_backlog_item_order_path(product_id: product.id.to_s, format: :js), params: params

      order = ProductBacklogItemOrderRepository::AR.find_by_product_id(product.id)
      expect(order.to_a).to eq [pbi_c, pbi_a, pbi_b].map(&:id)
    end
  end
end
