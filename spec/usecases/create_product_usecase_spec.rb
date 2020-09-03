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
      expect(product.description).to eq 'DESC'
      expect(product.owner).to eq person.id

      expect(plan.release(1).title).to eq 'Icebox'
      expect(plan.release(1).items).to be_empty
    end
  end
end
