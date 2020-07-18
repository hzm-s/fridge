# typed: false
require 'rails_helper'

RSpec.describe CreateProductUsecase do
  it do
    product_id = described_class.perform('fridge', 'DESC')
    product = ProductRepository::AR.find_by_id(product_id)

    aggregate_failures do
      expect(product.name).to eq 'fridge'
      expect(product.description).to eq 'DESC'
    end
  end
end
