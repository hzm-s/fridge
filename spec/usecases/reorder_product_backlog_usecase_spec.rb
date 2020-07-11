require 'rails_helper'

RSpec.describe 'Reorder Product Backlog' do
  it do
    product = create_product

    pbi_a = add_pbi(product.id, 'AAA')
    pbi_b = add_pbi(product.id, 'BBB')
    pbi_c = add_pbi(product.id, 'CCC')

    uc = ReorderProductBacklogUsecase.new
    uc.perform(product.id, pbi_a.id, pbi_c.id)

    order = ProductBacklogItemOrderRepository::AR.find_by_product_id(product.id)
    expect(order.to_a).to eq [pbi_b, pbi_c, pbi_a].map(&:id)
  end
end
