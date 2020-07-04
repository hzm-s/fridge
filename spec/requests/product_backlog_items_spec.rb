require 'rails_helper'

RSpec.describe 'product_backlog_items' do
  let!(:product) { create_product }

  describe '#create' do
    let(:valid_params) do
      {
        form: {
          product_id: product.id.to_s,
          content: 'ABC'
        }
      }
    end

    context '入力内容が正しい場合' do
      it do
        post product_backlog_items_path(format: :js), params: valid_params

        get product_backlog_items_path(product_id: product.id.to_s)

        expect(response.body).to include('ABC')
      end
    end

    context '入力内容が正しくない場合' do
      it do
        params = valid_params.deep_merge(form: { content: '' })
        post product_backlog_items_path(format: :js), params: params

        expect(response.body).to include(I18n.t('errors.messages.blank'))
      end
    end
  end

  describe '#show' do
    it do
      add_pbi(product.id, 'AAA')
      pbi_id = add_pbi(product.id, 'BBB')
      add_pbi(product.id, 'CCC')

      get product_backlog_item_path(pbi_id.to_s)

      expect(response.body).to include('BBB')
    end
  end
end
