# typed: false
require 'rails_helper'

RSpec.describe AddReleaseUsecase do
  let!(:product) { create_product }

  before do
    add_feature(product.id)
  end

  it do
    id = described_class.perform(product.id, 'MVP')
    release = ReleaseRepository::AR.find_by_id(id)

    expect(release.product_id).to eq product.id
    expect(release.title).to eq 'MVP'
    expect(release.items).to be_empty
  end
end
