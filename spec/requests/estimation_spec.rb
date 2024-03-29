# typed: false
require 'rails_helper'

describe 'estimation' do
  let!(:user_account) { sign_up }
  let!(:product) { create_product(person: user_account.person_id, roles: team_roles(:dev)) }
  let!(:pbi) { add_pbi(product.id, type: :feature) }

  describe '#update' do
    before { sign_in(user_account) }

    context 'given valid params' do
      it do
        put pbi_estimation_path(pbi_id: pbi.id, format: :js), params: { form: { size: '8' } }

        stored = PbiRepository::AR.find_by_id(pbi.id)
        expect(stored.size.to_i).to eq 8
      end

      it do
        put pbi_estimation_path(pbi_id: pbi.id, format: :js), params: { form: { size: '?' } }

        stored = PbiRepository::AR.find_by_id(pbi.id)
        expect(stored.size.to_i).to be_nil
      end
    end

    context 'given invalid params' do
      it do
        put pbi_estimation_path(pbi_id: pbi.id, format: :js), params: { form: { size: '100' } }
        follow_redirect!

        expect(response.body).to include(I18n.t('domain.errors.pbi.invalid_story_point'))
      end
    end

    it do
      put pbi_estimation_path(pbi_id: pbi.id, format: :js), params: { form: { size: '2' } }
      expect(response.body).to_not include 'test-item-movable'
    end
  end

  it_behaves_like('sign_in_guard') { let(:r) { put pbi_estimation_path(1, format: :js) } }
end
