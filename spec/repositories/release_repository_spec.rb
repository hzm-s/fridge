# typed: false
require 'rails_helper'

RSpec.describe ReleaseRepository::AR do
  let!(:product) { create_product }

  it do
    release1 = Release::Release.create(product.id, 'R1')
    described_class.add(release1)
    release2 = Release::Release.create(product.id, 'R2')
    described_class.add(release2)
    release3 = Release::Release.create(product.id, 'R3')
    described_class.add(release3)

    plan = described_class.find_plan_by_product_id(product.id)
    expect(plan.map(&:id)).to eq [release1, release2, release3].map(&:id)
  end

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
