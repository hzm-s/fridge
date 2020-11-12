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
      item_a = add_issue(product.id).id
      item_b = add_issue(product.id).id
      item_c = add_issue(product.id).id

      post product_releases_path(product_id: product.id.to_s), params: { name: 'MVP', issue_id: item_b }

      pbl = ProductBacklogQuery.call(product.id.to_s)
      expect(pbl.scoped.size).to eq 1
      expect(pbl.scoped[0].items.map(&:id)).to eq [item_a, item_b].map(&:to_s)
      expect(pbl.unscoped.map(&:id)).to eq [item_c].map(&:to_s)
    end
  end
end
