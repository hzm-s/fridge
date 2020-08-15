# typed: false
require 'rails_helper'

RSpec.describe ReleaseRepository::AR do
  let!(:product) { create_product }

  it do
    release = Release::Release.create(product.id, 'Icebox')

    item_a = Pbi::Id.create
    item_b = Pbi::Id.create
    item_c = Pbi::Id.create

    release.add_item(item_a)
    release.add_item(item_b)
    described_class.add(release)

    release.add_item(item_c)
    described_class.update(release)

    stored = described_class.find_by_id(release.id)

    expect(stored.items).to eq [item_a, item_b, item_c]
  end
end
