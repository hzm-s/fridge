# typed: false
require 'rails_helper'

RSpec.describe SortProductBacklogUsecase do
  let!(:product) { create_product }
  let!(:release1) { add_release(product.id) }
  let!(:release2) { add_release(product.id) }
  let!(:item_a) { add_issue(product.id) }
  let!(:item_b) { add_issue(product.id) }
  let!(:item_c) { add_issue(product.id) }

  it do
    described_class.perform(item_a.id, nil, release1.id, 0)
    expect(fetch_release(release1.id).items.to_a).to include item_a.id

    described_class.perform(item_a.id, release1.id, nil, 999)
    expect(fetch_release(release1.id).items.to_a).to_not include item_a.id
  end

  private

  def fetch_release(id)
    ReleaseRepository::AR.find_by_id(id)
  end
end
