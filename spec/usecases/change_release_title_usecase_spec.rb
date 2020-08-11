# typed: false
require 'rails_helper'

RSpec.describe ChangeReleaseTitleUsecase do
  let!(:product) { create_product }

  before do
    add_pbi(product.id)
  end

  it do
    described_class.perform(product.id, 1, 'NEW_TITLE')
    plan = PlanRepository::AR.find_by_product_id(product.id)
    expect(plan.releases[0].title).to eq 'NEW_TITLE'
  end
end
