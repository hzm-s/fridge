require 'rails_helper'

RSpec.describe 'Create product' do
  it do
    uc = CreateProductUsecase.new

    product_id = uc.perform('fridge', 'DESC')
    product = ProductRepository::AR.find_by_id(product_id)

    aggregate_failures do
      expect(product.name).to eq 'fridge'
      expect(product.description).to eq 'DESC'
    end
  end
end
