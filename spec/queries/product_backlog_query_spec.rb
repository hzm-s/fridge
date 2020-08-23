# typed: false
require 'rails_helper'

RSpec.describe ProductBacklogQuery do
  let!(:product) { create_product }

  it '優先順位順になっていること' do
    feature_a = add_feature(product.id, 'AAA').id
    feature_b = add_feature(product.id, 'BBB').id
    feature_c = add_feature(product.id, 'CCC').id

    item_ids = described_class.call(product.id.to_s)[0].items.map(&:id)

    expect(item_ids).to eq [feature_a, feature_b, feature_c].map(&:to_s)
  end

  xit 'リリースを返すこと' do
    feature_a = add_feature(product.id, 'AAA').id
    feature_b = add_feature(product.id, 'BBB').id
    feature_c = add_feature(product.id, 'CCC').id

    release = described_class.call(product.id.to_s).first

    expect(release.title).to eq Release::Release::DEFAULT_TITLE
  end

  xit 'リリースの削除可否を返すこと' do
    add_feature(product.id, 'AAA')

    releases = described_class.call(product.id.to_s)

    expect(releases.first).to_not be_can_remove
  end

  it 'アイテムがまだない場合は空配列を返すこと' do
    pbl = described_class.call(product.id.to_s)
    expect(pbl).to be_empty
  end

  xit '受け入れ基準がある場合は受け入れ基準を含むこと' do
    feature = add_feature(product.id, acceptance_criteria: %w(ac1 ac2 ac3))

    item = described_class.call(product.id.to_s)[0].items.first
    expect(item.criteria.map(&:content)).to eq %w(ac1 ac2 ac3) 
  end

  xit '各操作の可否を返すこと' do
    feature = add_feature(product.id, acceptance_criteria: %w(ac1), size: 1)

    item = described_class.call(product.id.to_s)[0].items.first

    aggregate_failures do
      expect(item.status).to be_can_assign
      expect(item.status).to_not be_can_cancel_assignment
      expect(item.status).to be_can_remove
      expect(item.status).to be_can_estimate_size
    end
  end
end
