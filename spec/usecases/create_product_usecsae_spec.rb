# typed: false
require 'rails_helper'

RSpec.describe CreateProductUsecase do
  it do
    product_id = described_class.perform('abc', 'xyz')

    product = ProductRepository::AR.find_by_id(product_id)
    plan = PlanRepository::AR.find_by_product_id(product_id)

    aggregate_failures do
      expect(product.name).to eq 'abc'
      expect(product.description).to eq 'xyz'

      expect(plan.scheduled.to_a).to be_empty
    end
  end
end
