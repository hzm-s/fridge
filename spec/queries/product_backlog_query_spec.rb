# typed: false
require 'rails_helper'

RSpec.describe ProductBacklogQuery do
  let!(:product) { create_product }

  it 'アイテムは優先順位順になっていること' do
    item_a = add_issue(product.id).id
    item_b = add_issue(product.id).id
    item_c = add_issue(product.id).id
    item_d = add_issue(product.id).id
    item_e = add_issue(product.id).id

    SwapOrderedIssuesUsecase.perform(product.id, item_d, 1)

    pbl = described_class.call(product.id.to_s)

    expect(pbl.items.map(&:id)).to eq [item_a, item_d, item_b, item_c, item_e].map(&:to_s)
  end
end
