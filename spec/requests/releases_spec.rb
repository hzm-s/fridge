# typed: false
require 'rails_helper'

RSpec.describe 'releases' do
  let!(:user_account) { sign_up }
  let!(:product) { create_product(person: user_account.person_id) }

  before do
    sign_in(user_account)
  end

  describe 'create' do
    context 'given valid params' do
      it do
        post product_releases_path(product_id: product.id.to_s), params: { form: { description: 'MVP' } }

        pbl = ProductBacklogQuery.call(product.id.to_s)

        aggregate_failures do
          expect(pbl.releases[1].number).to eq 2
          expect(pbl.releases[1].description).to eq 'MVP'
          expect(pbl.releases[1].issues).to be_empty
        end
      end
    end

    context 'given invalid params' do
      it do
        post product_releases_path(product_id: product.id.to_s), params: { form: { description: 'a' * 101 } }

        expect(response.body).to include(I18n.t('errors.messages.too_long', count: 100))
      end
    end
  end

  describe 'edit' do
    before do
      update_release(product.id, 1) { |r| r.modify_description('ファーストリリース') }
    end

    it do
      get edit_product_release_path(product_id: product.id, number: 1)
      expect(response.body).to include 'ファーストリリース'
    end
  end

  describe 'update' do
    before do
      update_release(product.id, 1) { |r| r.modify_description('MVP') }
      append_release(product.id, 2, description: 'Extra')
    end

    context 'given valid params' do
      it do
        patch product_release_path(product_id: product.id, number: 2), params: { form: { description: '2nd Release' } }

        pbl = ProductBacklogQuery.call(product.id.to_s)
        aggregate_failures do
          expect(pbl.releases[0].description).to eq 'MVP'
          expect(pbl.releases[1].description).to eq '2nd Release'
        end
      end
    end

    context 'given invalid params' do
      it do
        patch product_release_path(product_id: product.id, number: 1), params: { form: { description: 'a' * 101 } }

        expect(response.body).to include(I18n.t('errors.messages.too_long', count: 100))
      end
    end
  end

  xdescribe 'destroy' do
    before do
      add_release(product.id, 'R1')
      add_release(product.id, 'R2')
      add_issue(product.id, release: 'R1')
    end

    it do
      delete product_release_path(product_id: product.id, id: 1)

      pbl = ProductBacklogQuery.call(product.id.to_s)

      aggregate_failures do
        expect(pbl.scheduled.size).to eq 1
        expect(pbl.scheduled[0].name).to eq 'R1'
      end
    end

    it do
      delete product_release_path(product_id: product.id, id: 0)
      follow_redirect!
      expect(response.body).to include 'アイテムを含むリリースは削除できません'
    end
  end
end
