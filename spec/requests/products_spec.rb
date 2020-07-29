# typed: false
require 'rails_helper'

RSpec.describe 'products' do
  let(:user) { sign_up }

  before do
    sign_in(user)
  end

  describe '#create' do
    context 'given valid params' do
      it do
        params = { form: { name: 'fridge', description: 'setsumei_of_product', member_role: 'developer' } }
        post products_path(format: :js), params: params
        get products_path

        aggregate_failures do
          expect(response.body).to include('fridge')
          expect(response.body).to include('setsumei_of_product')
        end
      end
    end

    context 'given invalid params' do
      it do
        params = { form: { name: '' } }
        post products_path(format: :js), params: params

        expect(response.body).to include(I18n.t('errors.messages.blank'))
      end
    end
  end

  describe '#index' do
    it do
      expect(ProductQuery).to receive(:call).with(user.id)
      get products_path
    end
  end
end
