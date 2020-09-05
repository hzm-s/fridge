# typed: false
require 'rails_helper'

RSpec.describe 'pbi_estimation' do
  let!(:user_account) { sign_up }
  let!(:product) { create_product(owner: user_account.person_id) }
  let!(:pbi) { add_pbi(product.id) }

  describe '#update' do
    it do
      put pbi_estimation_path(pbi.id, format: :js), params: { form: { point: '8' } }

      updated = PbiRepository::AR.find_by_id(pbi.id)
      expect(updated.size.to_i).to eq 8
    end

    it do
      put pbi_estimation_path(pbi.id, format: :js), params: { form: { point: '?' } }

      updated = PbiRepository::AR.find_by_id(pbi.id)
      expect(updated.size.to_i).to eq nil 
    end
  end
end
