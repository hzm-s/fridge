# typed: false
require 'rails_helper'

RSpec.describe 'orders' do
  let!(:user_account) { sign_up }
  let!(:product) { create_product(owner: user_account.person_id) }

  before do
    sign_in(user_account)
  end

  describe 'update' do
    it do
      item_a = add_issue(product.id, 'ITEM_AAA').id
      item_b = add_issue(product.id, 'ITEM_BBB').id
      item_c = add_issue(product.id, 'ITEM_CCC').id

      params = {
        issue_id: item_c.to_s,
        to_index: 0,
      }
      patch order_path(product.id.to_s, format: :json), params: params

      pbl = ProductBacklogQuery.call(product.id.to_s)
      expect(pbl.items.map(&:id)).to eq [item_c, item_a, item_b].map(&:to_s)
    end
  end
end
