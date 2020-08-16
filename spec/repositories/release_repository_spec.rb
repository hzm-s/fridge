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

  describe 'find_last_by_product_id' do
    it do
      release = described_class.find_last_by_product_id(product.id)
      expect(release).to be_nil
    end

    it do
      add_release(product.id, 'R2')
      last = add_release(product.id, 'R3')

      release = described_class.find_last_by_product_id(product.id)
      expect(release.id).to eq last.id
    end
  end
end
