# typed: false
require 'rails_helper'

RSpec.describe 'orders' do
  let!(:user_account) { sign_up }
  let!(:product) { create_product(owner: user_account.person_id) }

  before do
    sign_in(user_account)
  end

  describe 'update' do
    xit do
      item_a = add_issue(product.id, 'ITEM_AAA')
      item_b = add_issue(product.id, 'ITEM_BBB')
      item_c = add_issue(product.id, 'ITEM_CCC')
    end
  end
end
