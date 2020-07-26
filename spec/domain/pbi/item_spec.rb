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

      it do
        expect(pbi.status).to eq Statuses::Draft

        pbi.update_content(Content.new('new content'))
        expect(pbi.status).to eq Statuses::Draft

        pbi.add_acceptance_criterion('ac1')
        expect(pbi.status).to eq Statuses::Draft

        pbi.estimate_size(StoryPoint.new(5))
        expect(pbi.status).to eq Statuses::Preparation

        pbi.remove_acceptance_criterion(1)
        expect(pbi.status).to eq Statuses::Draft

        pbi.add_acceptance_criterion('ac2')
        expect(pbi.status).to eq Statuses::Preparation

        pbi.estimate_size(StoryPoint.unknown)
        expect(pbi.status).to eq Statuses::Draft
      end
    end
  end
end
