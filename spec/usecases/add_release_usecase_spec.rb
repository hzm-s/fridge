# typed: false
require 'rails_helper'

RSpec.describe AddReleaseUsecase do
  let!(:product) { create_product }

  before do
    add_pbi(product.id)
  end

  it do
    described_class.perform(product.id, 'Slice2')
    plan = PlanRepository::AR.find_by_product_id(product.id)
    expect(plan.releases.last).to eq Plan::Release.new('Slice2', [])
  end
end
