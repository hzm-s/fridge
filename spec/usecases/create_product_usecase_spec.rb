require 'rails_helper'

RSpec.describe 'Create product' do
  it do
    uc = CreateProductUsecase.new

    product_id = uc.perform('fridge')
    product = ProductRepository::AR.find_by_id(product_id)

    expect(product.name).to eq 'fridge'
  end
end
