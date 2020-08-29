# typed: false
require 'rails_helper'

RSpec.describe AddReleaseUsecase do
  let!(:product) { create_product }

  it do
    described_class.perform(product.id, 'MVP')

    plan = PlanRepository::AR.find_by_product_id(product.id)
    release = plan.last_release

    expect(release.title).to eq 'MVP'
    expect(release.items).to be_empty
  end
end
