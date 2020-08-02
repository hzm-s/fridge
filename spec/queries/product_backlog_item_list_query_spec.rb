# typed: false
require 'rails_helper'

RSpec.describe ProductBacklogItemListQuery do
  let!(:product) { create_product }

  it '優先順位順になっていること' do
    pbi_a = add_pbi(product.id, 'AAA')
    pbi_b = add_pbi(product.id, 'BBB')
    pbi_c = add_pbi(product.id, 'CCC')
    SortProductBacklogUsecase.perform(product.id, pbi_c.id, 2)

    item_ids = described_class.call(product.id.to_s).map(&:id)

    expect(item_ids).to eq [pbi_a, pbi_c, pbi_b].map(&:id).map(&:to_s)
  end

  it 'PBIがまだない場合は空配列を返すこと' do
    items = described_class.call(product.id.to_s)
    expect(items).to be_empty
  end

  it '受け入れ基準がある場合は受け入れ基準を含むこと' do
    pbi = add_pbi(product.id, acceptance_criteria: %w(ac1 ac2 ac3))

    item = described_class.call(product.id.to_s).first
    expect(item.criteria.map(&:content)).to eq %w(ac1 ac2 ac3) 
  end

  it '作業予定にできるかを返すこと' do
    pbi = add_pbi(product.id, acceptance_criteria: %w(ac1), size: 1)

    item = described_class.call(product.id.to_s).first
    expect(item.status).to be_can_assign
  end
end
