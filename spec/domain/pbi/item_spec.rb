# typed: false
require 'rails_helper'

module Pbi
  describe Item do
    let!(:product_id) { Product::Id.create }
    let!(:content) { Pbi::Content.new('ABC') }

    describe '.create' do
      it 'id,product_id,内容を持つこと' do
        pbi = described_class.create(product_id, content)

        aggregate_failures do
          expect(pbi.id).to_not be_nil
          expect(pbi.product_id).to eq product_id
          expect(pbi.content).to eq content
        end
      end

      it 'ステータスは準備中であること' do
        pbi = described_class.create(product_id, content)
        expect(pbi.status).to eq Pbi::Status::Preparation
      end

      it 'サイズは不明であること' do
        pbi = described_class.create(product_id, content)
        expect(pbi.size).to eq Pbi::StoryPoint.unknown
      end

      it '受け入れ基準は空であること' do
        pbi = described_class.create(product_id, content)
        expect(pbi.acceptance_criteria).to be_empty
      end
    end

    describe '#update_content' do
      it do
        pbi = described_class.create(product_id, content)

        new_content = Content.new('NEW_CONTENT')
        pbi.update_content(new_content)

        expect(pbi.content).to eq(new_content)
      end
    end
  end
end
