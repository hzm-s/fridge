# typed: false
require 'rails_helper'

RSpec.describe PlanRepository::AR do
  let!(:product) { create_product }

  it do
    plan = Plan::Plan.create(product.id)
    item_a = Pbi::Id.create
    item_b = Pbi::Id.create
    item_c = Pbi::Id.create

    plan.add_item(item_a)
    plan.add_item(item_b)
    plan.add_release('Extra')
    plan.add_item(item_c)

    described_class.add(plan)
    saved = described_class.find_by_product_id(product.id)

    expect(saved.product_id).to eq product.id
    expect(saved.releases.map(&:to_h)).to eq [
      {
        title: 'Untitled',
        items: [item_a, item_b].map(&:to_s)
      },
      {
        title: 'Extra',
        items: [item_c].map(&:to_s)
      }
    ]
  end
end
