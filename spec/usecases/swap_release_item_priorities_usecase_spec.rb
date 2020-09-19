# typed: false
require 'rails_helper'

RSpec.describe SwapReleaseItemPrioritiesUsecase do
  let!(:product) { create_product }
  let!(:release) { add_release(product.id) }
  let!(:item_a) { add_issue(product.id, release: release.id).id }
  let!(:item_b) { add_issue(product.id, release: release.id).id }

  it do
    described_class.perform(release.id, item_a, 1)
    stored = ReleaseRepository::AR.find_by_id(release.id)
    expect(stored.items).to eq Release::ItemList.new([item_b, item_a])
  end
end
