require 'rails_helper'

RSpec.describe 'Estimate PBI size' do
  it do
    product = create_product
    pbi_id = add_pbi(product.id, 'ABC')
    repository = ProductBacklogItemRepository::AR
    uc = EstimateProductBacklogItemSizeUsecase.new

    point = Pbi::StoryPoint.from_integer(8)
    id = uc.perform(pbi_id, point)

    pbi = repository.find_by_id(id)
    expect(pbi.size).to eq(point)
  end
end
