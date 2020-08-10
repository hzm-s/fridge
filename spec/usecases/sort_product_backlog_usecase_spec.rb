# typed: false
require 'rails_helper'

RSpec.describe SortProductBacklogUsecase do
  let!(:product) { create_product }

  it do
    pbi_a = add_pbi(product.id, 'AAA').id
    pbi_b = add_pbi(product.id, 'BBB').id
    pbi_c = add_pbi(product.id, 'CCC').id

    described_class.perform(product.id, pbi_a, 3)

    plan = PlanRepository::AR.find_by_product_id(product.id)
    expect(plan.items.flatten).to eq [pbi_b, pbi_c, pbi_a]
  end
end
