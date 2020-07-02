require 'rails_helper'

RSpec.describe 'product_backlog_items' do
  let!(:product) { create_product }

  describe '#create' do
    it do
      params = {
        product_id: product.id.to_s,
        form: {
          content: 'ABC'
        }
      }

      post product_backlog_items_path(format: :js), params: params

      get product_backlog_items_path(product_id: product.id.to_s)

      expect(response.body).to include('ABC')
    end
  end
end
