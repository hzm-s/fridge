# typed: false
require 'rails_helper'

describe ProductBacklogQuery do
  let!(:product) { create_product }

  let!(:item_a) { add_issue(product.id).id }
  let!(:item_b) { add_issue(product.id).id }
  let!(:item_c) { add_issue(product.id).id }
  let!(:item_d) { add_issue(product.id).id }
  let!(:item_e) { add_issue(product.id).id }

  it do
    SwapOrderedIssuesUsecase.perform(product.id, item_d, 1)

    pbl = described_class.call(product.id.to_s)

    expect(pbl.unscoped.map(&:id)).to eq [item_a, item_d, item_b, item_c, item_e].map(&:to_s)
  end

  xit do
    SpecifyReleaseUsecase.perform(product.id, 'MVP', issue_b)

    pbl = described_class.call(product.id.to_s)
  end
end
