# typed: false
require 'rails_helper'

RSpec.describe 'product_backlogs' do
  let!(:user_account) { sign_up }
  let!(:product) { create_product(owner: user_account.person_id) }

  before do
    sign_in(user_account)
  end

  describe 'update' do
    it do
      release1 = add_release(product.id, 'Phase1')
      release2 = add_release(product.id, 'Phase2')

      item_a = add_issue(product.id, 'ITEM_AAA')
      item_b = add_issue(product.id, 'ITEM_BBB')
      item_c = add_issue(product.id, 'ITEM_CCC')

      expect(SortProductBacklogUsecase).to receive(:perform).with(item_a.id, nil, release1.id, 0)
      patch product_backlog_path(product.id.to_s, format: :json), params: {
        item: item_a.id.to_s,
        from_release_id: nil,
        to_release_id: release1.id.to_s,
        new_index: 0
      }
    end
  end
end
