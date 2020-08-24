# typed: false
require 'rails_helper'

RSpec.describe ReleaseRepository::AR do
  let!(:product) { create_product }

  describe 'add & update' do
    it do
      r1 = Release::Release.create(product.id, 'R1')
      described_class.add(r1)
      r2 = Release::Release.create(product.id, 'R2')
      described_class.add(r2)
      r3 = Release::Release.create(product.id, 'R3')
      described_class.add(r3)

      all = described_class.all_by_product_id(product.id)
      expect(all.map(&:id)).to eq [r1, r2, r3].map(&:id)
    end

    it do
      release = Release::Release.create(product.id, 'Icebox')

      item_a = Feature::Id.create
      item_b = Feature::Id.create
      item_c = Feature::Id.create

      release.add_item(item_a)
      release.add_item(item_b)
      described_class.add(release)

      release.add_item(item_c)
      described_class.update(release)

      stored = described_class.find_by_id(release.id)

      expect(stored.items).to match_array [item_a, item_b, item_c]
    end
  end
end
