# typed: false
require 'rails_helper'

module Pbi
  describe Item do
    let!(:product_id) { Product::Id.create }
    let!(:content) { Content.new('ABC') }

    describe '.create' do
      it 'id,product_id,内容を持つこと' do
        pbi = described_class.create(product_id, content)

        aggregate_failures do
          expect(pbi.id).to_not be_nil
          expect(pbi.product_id).to eq product_id
          expect(pbi.content).to eq content
        end
      end

      it 'サイズは不明であること' do
        pbi = described_class.create(product_id, content)
        expect(pbi.size).to eq StoryPoint.unknown
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

    describe 'status' do
      let(:pbi) { described_class.create(product_id, content) }

      context '新規作成時' do
        it '下書きであること' do
          expect(pbi.status).to eq Statuses::Draft
        end
      end

      context '内容を更新した場合' do
        it '変わらないこと' do
          expect { pbi.update_content(Content.new('NEW')) }
            .to_not change { pbi.status }
        end
      end

      context '受け入れ基準が1つになった場合' do
        it '準備中になること' do
          pbi.add_acceptance_criterion('AC')
          expect(pbi.status).to eq Statuses::Preparation
        end
      end

      context '受け入れ基準が2つ以上になった場合' do
        it '準備中から変わらないこと' do
          pbi.add_acceptance_criterion('AC1')
          pbi.add_acceptance_criterion('AC2')
          expect(pbi.status).to eq Statuses::Preparation
        end
      end
    end
  end
end
