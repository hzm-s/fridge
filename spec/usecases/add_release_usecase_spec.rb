# typed: false
require 'rails_helper'

RSpec.describe AddReleaseUsecase do
  let!(:product) { create_product }

  before do
    add_pbi(product.id)
  end

  it do
    id = described_class.perform(product.id, 'Bonus')
    release = ReleaseRepository::AR.find_by_id(id)

    expect(release.product_id).to eq product.id
    expect(release.title).to eq 'Bonus'
  end
end
