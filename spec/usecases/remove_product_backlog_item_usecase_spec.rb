# typed: false
require 'rails_helper'

RSpec.describe RemoveProductBacklogItemUsecase do
  let!(:product) { create_product }
  let!(:item) { add_pbi(product.id) }

  it 'DBとリリースに存在しないこと' do
    target = add_pbi(product.id)
    described_class.perform(target.id)

    expect { ProductBacklogItemRepository::AR.find_by_id(target.id) }
      .to raise_error(ActiveRecord::RecordNotFound)

    release = ReleaseRepository::AR.find_last_by_product_id(product.id)
    expect(release.items).to match_array [item.id]
  end

  it '作業予定アイテムは削除できないこと' do
    assigned = add_pbi(product.id, acceptance_criteria: %w(criterion), size: 8, assigned: true)

    expect { described_class.perform(assigned.id) }
      .to raise_error(Pbi::ItemCanNotRemove)
  end

  it do
    add_release(product.id, 'R2')
    item2 = add_pbi(product.id)
    add_release(product.id, 'R3')
    item3 = add_pbi(product.id)

    described_class.perform(item2.id)

    releases = ReleaseRepository::AR.all_by_product_id(product.id)
    expect(releases.map(&:items)).to eq [[item.id], [], [item3.id]]
  end
end
