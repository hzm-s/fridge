# typed: false
require 'rails_helper'

describe 'pbi_estimation' do
  let!(:user_account) { sign_up }
  let!(:product) { create_product(person: user_account.person_id, roles: team_roles(:dev)) }
  let!(:pbi) { add_pbi(product.id, type: :feature) }

  describe '#update' do
    before { sign_in(user_account) }

    it do
      put pbi_estimation_path(pbi_id: pbi.id, format: :js), params: { form: { point: '8' } }

      stored = PbiRepository::AR.find_by_id(pbi.id)
      expect(stored.size.to_i).to eq 8
    end

    it do
      put pbi_estimation_path(pbi_id: pbi.id, format: :js), params: { form: { point: '?' } }

      stored = PbiRepository::AR.find_by_id(pbi.id)
      expect(stored.size.to_i).to be_nil
    end

    it do
      put pbi_estimation_path(pbi_id: pbi.id, format: :js), params: { form: { point: '2' } }
      expect(response.body).to_not include 'test-item-movable'
    end
  end

  it_behaves_like('sign_in_guard') { let(:r) { put pbi_estimation_path(1, format: :js) } }
end
