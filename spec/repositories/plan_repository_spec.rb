# typed: false
require 'rails_helper'

RSpec.describe PlanRepository::AR do
  describe 'add' do
    it do
      product_id = Product::Id.create
      owner = sign_up_as_person
      Dao::Product.create!(id: product_id, name: 'P', owner_id: owner.id)

      plan = Plan::Plan.create(product_id)
      release = Plan::Release.create('MVP')
      plan.add_release(release)

      described_class.add(plan)

      rels = Dao::Release.all
      expect(rels.size).to eq 1
      expect(rels[0].dao_product_id).to eq plan.product_id.to_s
      expect(rels[0].title).to eq 'MVP'
      expect(rels[0].items).to be_empty
    end
  end

  describe 'update' do
    let!(:product) { create_product }
    let!(:other_product) { create_product }

    it do
      item_a = Pbi::Id.create
      item_b = Pbi::Id.create
      item_c = Pbi::Id.create

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
