# typed: false
require 'rails_helper'

RSpec.describe ProductBacklogQuery do
  let!(:product) { create_product }

  context 'アイテムがない場合' do
    it do
      pbl = described_class.call(product.id.to_s)
      expect(pbl).to be_empty
    end
  end

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

  context 'リリース未確定のアイテムがある場合' do
    it '作成日時の昇順で返すこと' do
      issue_a = add_issue(product.id)
      issue_b = add_issue(product.id)
      issue_c = add_issue(product.id)

      pbl = described_class.call(product.id.to_s)
      expect(pbl.icebox.items.map(&:id)).to eq [issue_a, issue_b, issue_c].map(&:id).map(&:to_s)
    end
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

    it 'リリースを返すこと' do
      add_release(product.id, 'Phase2')
      add_release(product.id, 'Phase3')

      pbl = described_class.call(product.id.to_s)

      numbers = pbl.releases.map(&:no)
      expect(numbers).to eq [1, 2, 3]

      titles = pbl.releases.map(&:title)
      expect(titles).to eq %w(Icebox Phase2 Phase3)
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
