require 'rails_helper'

RSpec.describe 'Add product backlog item' do
  let!(:product) { Product::Product.create('fridge') }
  let(:pbi_repo) { ProductBacklogItemRepository::AR }
  let(:order_repo) { ProductBacklogOrderRepository::AR }

  let(:uc) { AddProductBacklogItemUsecase.new }

  before { ProductRepository::AR.add(product) }

  it '追加したPBIが保存されていること' do
    pbi_id = uc.perform(product.id, Pbi::Content.from_string('aaa'))
    pbi = pbi_repo.find_by_id(pbi_id)

    expect(pbi.content.to_s).to eq 'aaa'
  end

  it '追加したPBIの優先順位は最低になっていること' do
    uc.perform(product.id, Pbi::Content.from_string('aaa'))

    pbi_id = uc.perform(product.id, Pbi::Content.from_string('bbb'))
    order = order_repo.find_by_product_id(product.id)

    expect(order.to_a.index(pbi_id)).to eq 1
  end
end
