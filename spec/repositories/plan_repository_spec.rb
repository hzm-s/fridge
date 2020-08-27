# typed: false
require 'rails_helper'

RSpec.describe PlanRepository::AR do
  let!(:product) { create_product }

  describe 'add' do
    it do
      release = Plan::Release.create('MVP')

      plan = Plan::Plan.create(product.id)
      plan.add_release(release)

      expect { described_class.add(plan) }
        .to change { Dao::Release.count }.by(1)

      rel = Dao::Release.last
      expect(rel.dao_product_id).to eq plan.product_id.to_s
      expect(rel.title).to eq 'MVP'
      expect(rel.items).to be_empty
    end
  end

  describe 'update' do
    it do
      item_a = Feature::Id.create
      item_b = Feature::Id.create
      item_c = Feature::Id.create

      plan = Plan::Plan.create(product.id)

      mvp = Plan::Release.create('MVP')
      mvp.add_item(item_a)
      plan.add_release(mvp)
      described_class.add(plan)

      extra = Plan::Release.create('EXTRA')
      extra.add_item(item_b)
      extra.add_item(item_c)
      plan.add_release(extra)

      expect { described_class.update(plan) }
        .to change { Dao::Release.count }.from(1).to(2)

      rels = Dao::Release.all
      expect(rels[0].title).to eq 'MVP'
      expect(rels[0].items).to eq [item_a.to_s]
      expect(rels[1].title).to eq 'EXTRA'
      expect(rels[1].items).to eq [item_b, item_c].map(&:to_s)
    end
  end
end
