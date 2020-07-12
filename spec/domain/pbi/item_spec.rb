require 'rails_helper'

module Pbi
  describe Item do
    let!(:product_id) { Product::ProductId.create }
    let!(:content) { Pbi::Content.from_string('ABC') }

    describe '.create' do
      it 'id,ProductId,内容を持つこと' do
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

    describe '#add_acceptance_criterion' do
      it do
        pbi = described_class.create(product_id, content)

        pbi.add_acceptance_criterion('AC_1')

        expect(pbi.acceptance_criterion(1)).to eq 'AC_1'
      end
    end
  end
end
