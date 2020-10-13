# typed: false
require 'rails_helper'

RSpec.describe PreparePlanUsecase do
  let(:product) { create_product }

  it do
    described_class.perform(product.id)

    plan = PlanRepository::AR.find_by_product_id(product.id)
    expect(plan.order).to be_empty
  end
end
