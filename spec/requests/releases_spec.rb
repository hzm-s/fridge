# typed: false
require 'rails_helper'

RSpec.describe 'releases' do
  let!(:user) { sign_up }
  let!(:product) { create_product(user_id: user_id(user.id)) }
  let!(:pbi) { add_pbi(product.id) }

  before do
    sign_in(user)
  end

  describe '#create' do
    it do
      post product_releases_path(product_id: product.id.to_s), params: { form: { title: 'SLICE2' } }
      follow_redirect!

      expect(response.body).to include 'SLICE2'
    end

    it do
      post product_releases_path(product_id: product.id.to_s), params: { form: { title: '' } }
      expect(response.body).to include I18n.t('errors.messages.blank')
    end
  end

  describe '#update' do
    it do
      patch product_release_path(product_id: product.id.to_s, no: 1), params: { form: { title: 'MVP' } }
      follow_redirect!

      expect(response.body).to include 'MVP'
    end

    it do
      patch product_release_path(product_id: product.id.to_s, no: 1), params: { form: { title: '' } }
      expect(response.body).to include I18n.t('errors.messages.blank')
    end
  end

  describe '#destroy' do
    it do
      add_release(product.id, 'EXTRA_RELEASE')

      delete product_release_path(product_id: product.id.to_s, no: 2)
      follow_redirect!

      expect(response.body).to_not include 'EXTRA_RELEASE'
    end

    it do
      add_pbi(product.id)

      delete product_release_path(product_id: product.id.to_s, no: 1)
      follow_redirect!

      expect(response.body).to include I18n.t('domain.errors.plan.can_not_remove_release')
    end

    it do
      remove_pbi(pbi.id)

      delete product_release_path(product_id: product.id.to_s, no: 1)
      follow_redirect!

      expect(response.body).to include I18n.t('domain.errors.plan.at_least_one_release_is_required')
    end
  end
end
