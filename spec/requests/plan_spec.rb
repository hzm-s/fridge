# typed: false
require 'rails_helper'

RSpec.describe 'plan' do
  let!(:user_account) { sign_up }
  let!(:product) { create_product(person_id: user_account.person_id) }
  let!(:pbi_a) { add_pbi(product.id).id }
  let!(:pbi_b) { add_pbi(product.id).id }
  let!(:pbi_c) { add_pbi(product.id).id }

  describe '#update' do
    it do
      params = {
        from_no: 1,
        item: pbi_c.to_s,
        to_no: 1,
        position: 2,
      }
      put product_plan_path(product_id: product.id.to_s, format: :json), params: params

      plan = PlanRepository::AR.find_by_product_id(product.id)
      release = plan.release(1)
      expect(release.items).to eq [pbi_a, pbi_c, pbi_b]
    end
  end
end
