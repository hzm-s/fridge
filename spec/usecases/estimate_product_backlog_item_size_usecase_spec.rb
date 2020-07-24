# typed: false
require 'rails_helper'

RSpec.describe EstimateProductBacklogItemSizeUsecase do
  let!(:product) { create_product }

  it do
    pbi = add_pbi(product.id, 'ABC')

    point = Pbi::StoryPoint.new(8)
    id = described_class.perform(pbi.id, point)

    pbi = ProductBacklogItemRepository::AR.find_by_id(id)
    expect(pbi.size).to eq(point)
  end
end
