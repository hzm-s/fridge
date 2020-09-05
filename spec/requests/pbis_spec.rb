# typed: false
require 'rails_helper'

RSpec.describe 'pbis' do
  let!(:user_account) { sign_up }
  let!(:product) { create_product(owner: user_account.person_id) }

  before do
    sign_in(user_account)
  end

  describe 'create' do
    context 'given valid params' do
      it do
        post product_pbis_path(product_id: product.id.to_s, format: :js), params: { form: { description: 'ABC' } }
        get product_pbis_path(product_id: product.id.to_s)

        expect(response.body).to include 'ABC'
      end
    end

    context 'given invalid params' do
      it do
        post product_pbis_path(product_id: product.id.to_s, format: :js), params: { form: { description: '' } }

        expect(response.body).to include(I18n.t('errors.messages.blank'))
      end
    end
  end

  describe 'edit' do
    it do
      pbi = add_pbi(product.id, 'XYZ')
      add_acceptance_criteria(pbi, %w(AC_123))

      get edit_pbi_path(pbi.id.to_s)

      aggregate_failures do
        expect(response.body).to include('XYZ')
        expect(response.body).to include('AC_123')
      end
    end
  end

  describe 'update' do
    let!(:pbi) { add_pbi(product.id, 'ABC') }

    context '入力内容が正しい場合' do
      it do
        patch pbi_path(pbi.id, format: :js), params: { form: { description: 'XYZ' } }
        follow_redirect!

        expect(response.body).to include('XYZ')
      end
    end

    context '入力内容が正しくない場合' do
      it do
        patch pbi_path(pbi.id, format: :js), params: { form: { description: '' } }
        expect(response.body).to include(I18n.t('errors.messages.blank'))
      end
    end
  end

  describe 'destroy' do
    it do
      pbi = add_pbi(product.id, 'YOHKYU')

      delete pbi_path(pbi.id)
      follow_redirect!

      expect(response.body).to_not include 'YOHKYU'
    end
  end
end
