# typed: false
require 'rails_helper'

describe 'releases' do
  let!(:user_account) { sign_up }
  let!(:product) { create_product(person: user_account.person_id) }

  describe 'create' do
    before { sign_in(user_account) }

    context 'given valid params' do
      it do
        post product_releases_path(product_id: product.id.to_s), params: { form: { title: 'MVP' } }

        pbl = ProductBacklogQuery.call(product.id.to_s)

        aggregate_failures do
          expect(pbl.releases[1].number).to eq 2
          expect(pbl.releases[1].title).to eq 'MVP'
          expect(pbl.releases[1].items).to be_empty
        end
      end
    end

    context 'given invalid params' do
      it do
        post product_releases_path(product_id: product.id.to_s), params: { form: { title: 'a' * 51 } }

        expect(response.body).to include(I18n.t('domain.errors.shared.invalid_name'))
      end
    end
  end

  describe 'edit' do
    before { sign_in(user_account) }

    before do
      update_release(product.id, 1) { |r| r.modify_title(name('ファーストリリース')) }
    end

    it do
      get edit_product_release_path(product_id: product.id, number: 1)
      expect(response.body).to include 'ファーストリリース'
    end
  end

  describe 'update' do
    before { sign_in(user_account) }

    before do
      update_release(product.id, 1) { |r| r.modify_title(name('MVP')) }
      append_release(product.id, 2, title: 'Extra')
    end

    context 'given valid params' do
      it do
        patch product_release_path(product_id: product.id, number: 2), params: { form: { title: '2nd Release' } }

        pbl = ProductBacklogQuery.call(product.id.to_s)
        aggregate_failures do
          expect(pbl.releases[0].title).to eq 'MVP'
          expect(pbl.releases[1].title).to eq '2nd Release'
        end
      end
    end

    context 'given invalid params' do
      it do
        patch product_release_path(product_id: product.id, number: 1), params: { form: { title: 'a' * 51 } }

        expect(response.body).to include(I18n.t('domain.errors.shared.invalid_name'))
      end
    end
  end

  describe 'destroy' do
    before { sign_in(user_account) }

    it do
      append_release(product.id)

      delete product_release_path(product_id: product.id, number: 2)

      pbl = ProductBacklogQuery.call(product.id.to_s)

      expect(pbl.releases.map(&:number)).to eq [1]
    end
  end

  it_behaves_like('sign_in_guard') { let(:r) { post product_releases_path(product_id: 1) } }
  it_behaves_like('sign_in_guard') { let(:r) { get edit_product_release_path(product_id: 1, number: 1) } }
  it_behaves_like('sign_in_guard') { let(:r) { patch product_release_path(product_id: 1, number: 2) } }
  it_behaves_like('sign_in_guard') { let(:r) { delete product_release_path(product_id: 1, number: 2) } }
end
