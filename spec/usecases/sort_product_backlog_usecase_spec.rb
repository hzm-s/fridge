# typed: false
require 'rails_helper'

RSpec.describe SortProductBacklogUsecase do
  let!(:product) { create_product }

  it do
    pbi_a = add_pbi(product.id, 'AAA')
    pbi_b = add_pbi(product.id, 'BBB')
    pbi_c = add_pbi(product.id, 'CCC')

    described_class.perform(product.id, pbi_a.id, 3)

    order = ProductBacklogItemOrderRepository::AR.find_by_product_id(product.id)
    expect(order.to_a).to eq [pbi_b, pbi_c, pbi_a].map(&:id)
  end
end
