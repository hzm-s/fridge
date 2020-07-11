require 'rails_helper'

RSpec.describe ProductBacklogItemListQuery do
  it do
    product = create_product

    pbi_a = add_pbi(product.id, 'AAA')
    pbi_b = add_pbi(product.id, 'BBB')
    pbi_c = add_pbi(product.id, 'CCC')
    ReorderProductBacklogUsecase.new.perform(product.id, pbi_c.id, 2)

    item_ids = described_class.call(product.id.to_s).map(&:id)
    
    expect(item_ids).to eq [pbi_a, pbi_c, pbi_b].map(&:id).map(&:to_s)
  end
end
