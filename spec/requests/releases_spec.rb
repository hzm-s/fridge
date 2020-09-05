# typed: false
require 'rails_helper'

RSpec.describe 'releases' do
  let!(:user_account) { sign_up }
  let!(:product) { create_product(owner: user_account.person_id) }

  before do
    sign_in(user_account)
  end

  describe '#create' do
    it do
      post product_releases_path(product_id: product.id.to_s), params: { form: { title: 'Phase5' } }
      follow_redirect!

      expect(response.body).to include 'Phase5'
    end

    it do
      post product_releases_path(product_id: product.id.to_s), params: { form: { title: '' } }
      expect(response.body).to include I18n.t('errors.messages.blank')
    end
  end

  describe '#update' do
    let!(:release) { add_release(product.id, 'FURUI_TITLE') }

    it do
      patch release_path(2, product_id: product.id.to_s), params: { form: { title: 'SHIN_TITLE' } }
      follow_redirect!

      expect(response.body).to include 'SHIN_TITLE'
    end

    it do
      patch release_path(2, product_id: product.id.to_s), params: { form: { title: '' } }
      expect(response.body).to include I18n.t('errors.messages.blank')
    end
  end

  describe '#destroy' do
    it do
      target = add_release(product.id, 'EXTRA_RELEASE')

      delete release_path(2, product_id: product.id.to_s)
      follow_redirect!

      expect(response.body).to_not include 'EXTRA_RELEASE'
    end
  end
end
