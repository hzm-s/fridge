# typed: false
require 'rails_helper'

RSpec.describe RemoveFeatureUsecase do
  let!(:product) { create_product }
  let!(:stay) { add_feature(product.id) }

  it 'DBとプロダクトバックログに存在しないこと' do
    target = add_feature(product.id)
    described_class.perform(target.id)

    expect { FeatureRepository::AR.find_by_id(target.id) }
      .to raise_error(ActiveRecord::RecordNotFound)

    pbl = ProductBacklogRepository::AR.find_by_product_id(product.id)
    expect(pbl.items).to match_array [stay.id]
  end

  it '着手アイテムは削除できないこと' do
    wip = add_feature(product.id, acceptance_criteria: %w(criterion), size: 8, assigned: true)

    expect { described_class.perform(wip.id) }.to raise_error(Feature::CanNotRemove)
  end

  xit do
    add_release(product.id, 'R2')
    item2 = add_pbi(product.id)
    add_release(product.id, 'R3')
    item3 = add_pbi(product.id)

    described_class.perform(item2.id)

    releases = ReleaseRepository::AR.all_by_product_id(product.id)
    expect(releases.map(&:items)).to eq [[item.id], [], [item3.id]]
  end
end
