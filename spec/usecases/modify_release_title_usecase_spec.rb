# typed: false
require 'rails_helper'

RSpec.describe ModifyReleaseTitleUsecase do
  let!(:product) { create_product }

  it do
    add_release(product.id, 'OLD_TITLE')

    described_class.perform(product.id, 2, 'NEW_TITLE')

    plan = PlanRepository::AR.find_by_product_id(product.id)
    stored = plan.release(2)

    expect(stored.title).to eq 'NEW_TITLE'
  end
end
