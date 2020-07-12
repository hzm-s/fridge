require 'rails_helper'

RSpec.describe 'acceptance_criteria' do
  let!(:product) { create_product }
  let!(:pbi) { add_pbi(product.id) }

  describe '#create' do
    context 'given valid params' do
      it do
        params = { form: { content: 'ukeire_kijyun' } }

        post product_backlog_item_acceptance_criteria_path(product_backlog_item_id: pbi.id, format: :js), params: params
        get product_product_backlog_items_path(product_id: product.id.to_s)

        expect(response.body).to include 'ukeire_kijyun'
      end
    end
  end
end
