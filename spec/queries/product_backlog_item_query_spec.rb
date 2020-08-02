# typed: false
require 'rails_helper'

RSpec.describe ProductBacklogItemQuery do
  let!(:product) { create_product }

  it '作業予定にできるかを返すこと' do
    pbi = add_pbi(product.id, acceptance_criteria: %w(ac1), size: 1)

    item = described_class.call(pbi.id.to_s)
    expect(item.status).to be_can_assign
  end
end
