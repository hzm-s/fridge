# typed: false
require 'rails_helper'

RSpec.describe CreateProductUsecase do
  let(:person) { sign_up_as_person }

  it do
    product_id = described_class.perform(person.id, 'fridge', 'DESC')

    product = ProductRepository::AR.find_by_id(product_id)
    plan = PlanRepository::AR.find_by_product_id(product_id)

    aggregate_failures do
      expect(product.name).to eq 'fridge'
      expect(product.owner).to eq person.id
      expect(product.description).to eq 'DESC'

      expect(plan).to_not be_nil
    end
  end
end
