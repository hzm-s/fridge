# typed: false
require 'rails_helper'

RSpec.describe 'product_backlog_items' do
  let!(:user) { sign_up }
  let!(:product) { create_product(user_id: User::Id.from_string(user.id)) }

  before do
    sign_in(user)
  end

  describe '#create' do
    let(:valid_params) do
      { form: { content: 'ABC' } }
    end

    context 'given valid params' do
      it do
        post product_product_backlog_items_path(product_id: product.id.to_s, format: :js), params: valid_params

        get product_product_backlog_items_path(product_id: product.id.to_s)

        expect(response.body).to include('ABC')
      end
    end

    context 'given invalid params' do
      it do
        params = valid_params.deep_merge(form: { content: '' })
        post product_product_backlog_items_path(product_id: product.id.to_s, format: :js), params: params

        expect(response.body).to include(I18n.t('errors.messages.blank'))
      end
    end
  end

  describe '#edit' do
    it do
      pbi = add_pbi(product.id, 'XYZ')
      add_acceptance_criteria(pbi, %w(AC_123))

      get edit_product_backlog_item_path(pbi.id.to_s)

      aggregate_failures do
        expect(response.body).to include('XYZ')
        expect(response.body).to include('AC_123')
      end
    end
  end

  describe '#update' do
    let!(:pbi) { add_pbi(product.id, 'ABC') }

    let(:valid_params) do
      { form: { content: 'XYZ' } }
    end

    context '入力内容が正しい場合' do
      it do
        patch product_backlog_item_path(pbi.id, format: :js), params: valid_params
        follow_redirect!

        expect(response.body).to include('XYZ')
      end
    end

    context '入力内容が正しくない場合' do
      it do
        params = valid_params.deep_merge(form: { content: '' })
        patch product_backlog_item_path(pbi.id, format: :js), params: params

        expect(response.body).to include(I18n.t('errors.messages.blank'))
      end
    end
  end

  describe '#destroy' do
    it do
      pbi = add_pbi(product.id, 'YOHKYU')

      delete product_backlog_item_path(pbi.id)
      follow_redirect!

      expect(response.body).to_not include 'YOHKYU'
    end
  end
end
