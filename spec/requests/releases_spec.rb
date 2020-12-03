# typed: false
require 'rails_helper'

RSpec.describe 'releases' do
  let!(:user_account) { sign_up }
  let!(:product) { create_product(owner: user_account.person_id) }

  before do
    sign_in(user_account)
  end

  describe 'create' do
    it do
      post product_releases_path(product_id: product.id.to_s), params: { name: 'MVP' }

      pbl = ProductBacklogQuery.call(product.id.to_s)

      aggregate_failures do
        expect(pbl.scoped.size).to eq 1
        expect(pbl.scoped[0].name).to eq 'MVP'
        expect(pbl.scoped[0].issues).to be_empty
        expect(pbl.not_scoped).to be_empty
      end
    end
  end
end
