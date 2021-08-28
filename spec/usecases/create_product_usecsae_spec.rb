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

      expect(plan.recent_release.number).to eq 1
      expect(plan.recent_release.title).to eq 'Release#1'
      expect(plan.recent_release.issues).to eq issue_list
    end
  end
end
