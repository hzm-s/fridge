require 'rails_helper'

RSpec.describe 'Estimate PBI size' do
  it do
    product = create_product
    pbi = add_pbi(product.id, 'ABC')
    uc = EstimateProductBacklogItemSizeUsecase.new

    point = Pbi::StoryPoint.from_integer(8)
    id = uc.perform(pbi.id, point)

    pbi = ProductBacklogItemRepository::AR.find_by_id(id)
    expect(pbi.size).to eq(point)
  end
end
