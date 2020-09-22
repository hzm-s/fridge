# typed: false
require 'rails_helper'

RSpec.describe ProductBacklogQuery do
  let!(:product) { create_product }

  it 'リリース未確定アイテムは作成日時の昇順になっていること' do
    item_a = add_issue(product.id).id.to_s
    item_b = add_issue(product.id).id.to_s
    item_c = add_issue(product.id).id.to_s

    pbl = described_class.call(product.id.to_s)
    expect(pbl.icebox.items.map(&:id)).to eq [item_a, item_b, item_c]
  end

  it 'リリースアイテムは優先順位順になっていること' do
    release1 = add_release(product.id)
    release2 = add_release(product.id)

    item_a = add_issue(product.id, release: release1.id).id
    item_b = add_issue(product.id, release: release1.id).id
    item_c = add_issue(product.id, release: release1.id).id
    item_d = add_issue(product.id, release: release2.id).id
    item_e = add_issue(product.id, release: release2.id).id

    ManageReleaseItemUsecase.perform(item_d, release2.id, release1.id, 1)

    pbl = described_class.call(product.id.to_s)
    items = pbl.releases.flat_map(&:items)

    expect(items.map(&:id)).to eq [item_a, item_d, item_b, item_c, item_e].map(&:to_s)
  end

  it 'リリースを返すこと' do
    pbl = described_class.call(product.id.to_s)
    expect(pbl.releases).to be_empty

    release = add_release(product.id, 'MVP')

    pbl = described_class.call(product.id.to_s)
    expect(pbl.releases[0].id).to eq release.id.to_s
    expect(pbl.releases[0].title).to eq 'MVP'
    expect(pbl.releases[0].items).to be_empty 
  end

  it 'リリースの削除可否を返すこと' do
    release = add_release(product.id, 'MVP')

    pbl = described_class.call(product.id.to_s)
    expect(pbl.releases[0]).to be_can_remove
  end
end
