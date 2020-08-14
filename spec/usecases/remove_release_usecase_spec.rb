# typed: false
require 'rails_helper'

RSpec.describe RemoveReleaseUsecase do
  let(:product) { create_product }

  before do
    add_pbi(product.id)
    add_release(product.id)
  end

  it do
    described_class.perform(product.id, 2)
    plan = PlanRepository::AR.find_by_product_id(product.id)
    expect(plan.releases.size).to eq 1
  end
end
