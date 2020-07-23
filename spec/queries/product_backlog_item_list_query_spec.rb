# typed: false
require 'rails_helper'

RSpec.describe ProductBacklogItemListQuery do
  let(:user) { register_user }
  let(:product) { create_product(user_id: user.id) }

  it '優先順位順になっていること' do
    pbi_a = add_pbi(product.id, 'AAA')
    pbi_b = add_pbi(product.id, 'BBB')
    pbi_c = add_pbi(product.id, 'CCC')
    ReorderProductBacklogUsecase.new.perform(product.id, pbi_c.id, 2)

    item_ids = described_class.call(product.id.to_s).map(&:id)

    expect(item_ids).to eq [pbi_a, pbi_c, pbi_b].map(&:id).map(&:to_s)
  end

  it 'PBIがまだない場合は空配列を返すこと' do
    items = described_class.call(product.id.to_s)
    expect(items).to be_empty
  end

  it '受け入れ基準がある場合は受け入れ基準を含むこと' do
    pbi = add_pbi(product.id)
    add_acceptance_criteria(pbi, ['ac1'])

    item = described_class.call(product.id.to_s)[0]
    expect(item.criteria.map(&:content)).to match_array ['ac1']
  end
end
