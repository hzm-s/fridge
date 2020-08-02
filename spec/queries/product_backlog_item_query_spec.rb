# typed: false
require 'rails_helper'

RSpec.describe ProductBacklogItemQuery do
  let!(:product) { create_product }

  it '作業予定にできるかを返すこと' do
    pbi = add_pbi(product.id, acceptance_criteria: %w(ac1), size: 1)

    item = described_class.call(pbi.id.to_s)
    expect(item.status).to be_can_assign
  end

  it '作業予定の取り下げができるかを返すこと' do
    pbi = add_pbi(product.id, acceptance_criteria: %w(ac1), size: 1)
    assign_pbi(pbi.id)

    item = described_class.call(pbi.id.to_s)
    expect(item.status).to be_can_cancel_assignment
  end
end
