# typed: false
require 'rails_helper'

RSpec.describe ProductBacklogQuery do
  let!(:product) { create_product }

  describe 'Item' do
    it '受け入れ基準がある場合は受け入れ基準を含むこと' do
      add_issue(product.id, acceptance_criteria: %w(ac1 ac2 ac3))

      pbl = described_class.call(product.id.to_s)
      item = pbl.icebox.items.first

      expect(item.criteria.map(&:content)).to eq %w(ac1 ac2 ac3) 
    end

    it 'ステータスを返すこと' do
      add_issue(product.id)

      pbl = described_class.call(product.id.to_s)
      item = pbl.icebox.items.first

      expect(item.status).to eq Issue::Statuses::Preparation
    end
  end

  context 'リリース未確定のアイテムがある場合' do
    it '作成日時の昇順で返すこと' do
      issue_a = add_issue(product.id)
      issue_b = add_issue(product.id)
      issue_c = add_issue(product.id)

      pbl = described_class.call(product.id.to_s)
      expect(pbl.icebox.items.map(&:id)).to eq [issue_a, issue_b, issue_c].map(&:id).map(&:to_s)
    end
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

  xcontext 'PBIがある場合' do
    let!(:pbi_a) { add_pbi(product.id, 'AAA').id }
    let!(:pbi_b) { add_pbi(product.id, 'BBB').id }
    let!(:pbi_c) { add_pbi(product.id, 'CCC').id }

    it '優先順位順になっていること' do
      pbl = described_class.call(product.id.to_s)
      items = pbl.releases.flat_map(&:items)

      expect(items.map(&:id)).to eq [pbi_a, pbi_b, pbi_c].map(&:to_s)
    end

    it 'リリースの削除可否を返すこと' do
      pbl = described_class.call(product.id.to_s)
      expect(pbl).to_not be_can_remove_release

      add_release(product.id, 'Extra')

      release = described_class.call(product.id.to_s).releases.last
      expect(release).to be_can_remove
    end
  end
end
