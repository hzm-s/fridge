# typed: false
require 'rails_helper'

RSpec.describe ReleaseRepository::AR do
  let(:product) { create_product }

  describe 'Add & Update' do
    it do
      item_a = add_pbi(product.id)
      item_b = add_pbi(product.id)
      item_c = add_pbi(product.id)

      release = Release::Release.create(product.id, 'MVP')
      release.add_item(item_a.id)

      described_class.add(release)
      rel = Dao::Release.eager_load(:items).last

      aggregate_failures do
        expect(rel.id).to eq release.id.to_s
        expect(rel.title).to eq 'MVP'
        expect(rel.previous_release_id).to be_nil

        expect(rel.items.map(&:dao_pbi_id)).to eq [item_a.id.to_s]
      end

      release.add_item(item_b.id)
      release.add_item(item_c.id)

      expect { described_class.update(release) }
        .to change { Dao::Release.count }.by(0)
        .and change { Dao::ReleaseItem.count }.from(1).to(3)

      rel = Dao::Release.eager_load(:items).last
      expect(rel.items.map(&:dao_pbi_id)).to eq [item_a.id, item_b.id, item_c.id].map(&:to_s)
    end
  end
end
