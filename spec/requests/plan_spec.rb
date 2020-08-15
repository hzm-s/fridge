# typed: false
require 'rails_helper'

RSpec.describe 'plan' do
  let!(:user) { sign_up }
  let!(:product) { create_product(user_id: user_id(user.id)) }
  let!(:pbi_a) { add_pbi(product.id).id }
  let!(:pbi_b) { add_pbi(product.id).id }
  let!(:pbi_c) { add_pbi(product.id).id }

  describe '#update' do
    it do
      release = ReleaseRepository::AR.find_plan_by_product_id(product.id)[0]
      params = {
        from_id: release.id,
        item_id: pbi_c.to_s,
        to_id: release.id,
        position: 2,
      }
      put product_plan_path(product_id: product.id.to_s, format: :json), params: params

      updated = ReleaseRepository::AR.find_by_id(release.id)
      expect(updated.items).to eq [pbi_a, pbi_c, pbi_b]
    end
  end
end
