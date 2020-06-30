require 'rails_helper'

RSpec.describe 'Add product backlog item' do
  let(:pbi_repo) { ProductBacklogItemRepository::AR }
  let(:order_repo) { ProductBacklogItemOrderRepository::AR }
  let!(:product) { Product::Product.new('fridge') }

  before do
    ProductRepository::AR.add(product)
  end

  it do
    uc = AddProductBacklogItemUsecase.new(pbi_repo, order_repo)

    pbi_a_id = uc.perform(product.id.to_s, 'aaa')
    pbi_a = pbi_repo.find_by_id(Product::BacklogItemId.from_string(pbi_a_id))

    expect(pbi_a.content).to eq 'aaa'

    pbi_b_id = uc.perform(product.id.to_s, 'bbb')
    order = order_repo.find_by_product_id(product.id)

    expect(order.position(Product::BacklogItemId.from_string(pbi_b_id))).to eq 1
  end
end
