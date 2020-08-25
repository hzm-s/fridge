# typed: false
require 'rails_helper'

RSpec.describe ProductBacklogQuery do
  let!(:product) { create_product }

  context 'フィーチャーがない場合' do
    it do
      pbl = described_class.call(product.id.to_s)

      aggregate_failures do
        expect(pbl.items).to be_empty
        expect(pbl.releases).to be_empty
      end
    end
  end

  context 'フィーチャーがある場合' do
    let!(:feature_a) { add_feature(product.id, 'AAA').id }
    let!(:feature_b) { add_feature(product.id, 'BBB').id }
    let!(:feature_c) { add_feature(product.id, 'CCC').id }

    it '優先順位順になっていること' do
      pbl = described_class.call(product.id.to_s)

      expect(pbl.items.map(&:id)).to eq [feature_a, feature_b, feature_c].map(&:to_s)
    end

    it 'リリースを返すこと' do
      add_release(product.id, 'Phase1')
      add_release(product.id, 'Phase2')
      add_release(product.id, 'Phase3')

      pbl = described_class.call(product.id.to_s)

      release_titles = pbl.releases.map(&:title)
      expect(release_titles).to eq %w(Phase1 Phase2 Phase3)
    end

    it 'リリース含まれるフィーチャーを優先順位順に返すこと' do
    end

    it 'リリースの削除可否を返すこと' do
      add_release(product.id, 'Icebox')

      release = described_class.call(product.id.to_s).releases.first

      expect(release).to be_can_remove
    end

    it '受け入れ基準がある場合は受け入れ基準を含むこと' do
      feature = add_feature(product.id, acceptance_criteria: %w(ac1 ac2 ac3))

      item = described_class.call(product.id.to_s).items.last

      expect(item.criteria.map(&:content)).to eq %w(ac1 ac2 ac3) 
    end

    it '各操作の可否を返すこと' do
      feature = add_feature(product.id, acceptance_criteria: %w(ac1), size: 1)

      item = described_class.call(product.id.to_s).items.last

      aggregate_failures do
        expect(item.status).to be_can_start_development
        expect(item.status).to_not be_can_abort_development
        expect(item.status).to be_can_remove
        expect(item.status).to be_can_estimate
      end
    end
  end
end
