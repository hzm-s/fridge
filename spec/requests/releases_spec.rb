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
          expect(pbl.scoped.size).to eq 1
          expect(pbl.scoped[0].name).to eq 'MVP'
          expect(pbl.scoped[0].issues).to be_empty
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
end
