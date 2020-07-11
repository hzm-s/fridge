require 'rails_helper'

RSpec.describe 'products' do
  describe '#create' do
    context '入力内容が正しい場合' do
      it do
        params = { form: { name: 'fridge', description: 'setsumei_of_product' } }
        post products_path(format: :js), params: params
        get products_path

        aggregate_failures do
          expect(response.body).to include('fridge')
          expect(response.body).to include('setsumei_of_product')
        end
      end
    end

    context '入力内容が正しくない場合' do
      it do
        params = { form: { name: '' } }
        post products_path(format: :js), params: params

        expect(response.body).to include(I18n.t('errors.messages.blank'))
      end
    end
  end
end
