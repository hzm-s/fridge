require 'rails_helper'

RSpec.describe 'Reorder product backlog' do
  it do
    product = create_product

    pbi_a = add_pbi(product.id, 'AAA')
    pbi_b = add_pbi(product.id, 'BBB')
    pbi_c = add_pbi(product.id, 'CCC')

    uc = ReorderProductBacklogUsecase.new
    uc.perform(product.id, pbi_a.id, 3)

    order = ProductBacklogItemOrderRepository::AR.find_by_product_id(product.id)
    expect(order.to_a).to eq [pbi_b, pbi_c, pbi_a].map(&:id)
  end
end
