# typed: false
require 'rails_helper'

RSpec.describe ReleaseRepository::AR do
  let(:product) { create_product }

  describe 'add' do
    it do
      item_a = add_pbi(product.id)
      item_b = add_pbi(product.id)
      item_c = add_pbi(product.id)

      previous_release_id = Release::Id.create
      release = Release::Release.create(product.id, 'MVP', previous_release_id)
      release.add_item(item_a.id)
      release.add_item(item_b.id)
      release.add_item(item_c.id)

      described_class.add(release)
      rels = Dao::Release.eager_load(:items).last

      aggregate_failures do
        expect(rels.id).to eq release.id.to_s
        expect(rels.title).to eq 'MVP'
        expect(rels.previous_release_id).to eq previous_release_id.to_s

        expect(rels.items[0].dao_pbi_id).to eq item_a.id.to_s
        expect(rels.items[1].dao_pbi_id).to eq item_b.id.to_s
        expect(rels.items[2].dao_pbi_id).to eq item_c.id.to_s
      end
    end
  end

  describe 'update' do
    let!(:product) { create_product }
    let!(:other_product) { create_product }

    it do

      plan = described_class.find_by_product_id(product.id)

      extra = Plan::Release.create('EXTRA')
      extra.add_item(item_a)
      extra.add_item(item_b)
      extra.add_item(item_c)
      plan.add_release(extra)

      described_class.update(plan)

      rels = Dao::Release.where(dao_product_id: product.id.to_s)
      expect(rels.size).to eq 2
      expect(rels[0].title).to eq 'Icebox'
      expect(rels[0].items).to be_empty
      expect(rels[1].title).to eq 'EXTRA'
      expect(rels[1].items).to eq [item_a, item_b, item_c].map(&:to_s)

      expect(Dao::Release.count).to eq 3
      expect(Dao::Release.find_by(dao_product_id: other_product.id.to_s)).to_not be_nil
    end
  end
end
