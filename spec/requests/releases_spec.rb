# typed: false
require 'rails_helper'

RSpec.describe 'releases' do
  let!(:user_account) { sign_up }
  let!(:product) { create_product(owner: user_account.person_id) }

  before do
    sign_in(user_account)
  end

  describe 'create' do
    context 'given valid params' do
      it do
        post product_releases_path(product_id: product.id.to_s), params: { form: { name: 'MVP' } }

        pbl = ProductBacklogQuery.call(product.id.to_s)

        aggregate_failures do
          expect(pbl.scheduled.size).to eq 1
          expect(pbl.scheduled[0].name).to eq 'MVP'
          expect(pbl.scheduled[0].issues).to be_empty
          expect(pbl.pending).to be_empty
        end
      end
    end

    context 'given invalid params' do
      it do
        post product_releases_path(product_id: product.id.to_s), params: { form: { name: '' } }

        expect(response.body).to include(I18n.t('errors.messages.blank'))
      end
    end
  end

  describe 'edit' do
    before do
      add_release(product.id, 'ファーストリリース')
    end

    it do
      get edit_product_release_path(product_id: product.id, id: 0)
      expect(response.body).to include 'ファーストリリース'
    end
  end

  describe 'update' do
    before do
      add_release(product.id, 'MVP')
      add_release(product.id, 'Extra')
    end

    context 'given valid params' do
      it do
        patch product_release_path(product_id: product.id, id: 1), params: { form: { name: '2nd Release' } }

        pbl = ProductBacklogQuery.call(product.id.to_s)

        aggregate_failures do
          expect(pbl.scheduled[0].name).to eq 'MVP'
          expect(pbl.scheduled[1].name).to eq '2nd Release'
        end
      end
    end

    context 'given invalid params' do
      it do
        patch product_release_path(product_id: product.id, id: 0), params: { form: { name: '' } }

        expect(response.body).to include(I18n.t('errors.messages.blank'))
      end
    end
  end
end
