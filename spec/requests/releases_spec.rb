# typed: false
require 'rails_helper'

RSpec.describe 'releases' do
  let!(:user_account) { sign_up }
  let!(:product) { create_product(person_id: user_account.person_id) }
  let!(:pbi) { add_pbi(product.id) }
  let!(:release) { ReleaseRepository::AR.find_last_by_product_id(product.id) }

  before do
    sign_in(user_account)
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
      patch release_path(id: release.id.to_s), params: { form: { title: 'MVP' } }
      follow_redirect!

      expect(response.body).to include 'MVP'
    end

    it do
      patch release_path(id: release.id.to_s), params: { form: { title: '' } }
      expect(response.body).to include I18n.t('errors.messages.blank')
    end
  end

  describe '#destroy' do
    it do
      target = add_release(product.id, 'EXTRA_RELEASE')

      delete release_path(id: target.id.to_s)
      follow_redirect!

      expect(response.body).to_not include 'EXTRA_RELEASE'
    end

    it do
      target = add_release(product.id, 'EXTRA_RELEASE')
      add_pbi(product.id)

      delete release_path(target.id)
      follow_redirect!

      expect(response.body).to include I18n.t('domain.errors.release.can_not_remove_release')
    end
  end
end
