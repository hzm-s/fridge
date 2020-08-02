# typed: false
require 'rails_helper'

module Pbi
  describe Item do
    let!(:product_id) { Product::Id.create }
    let!(:content) { Content.new('ABC') }

    describe '.create' do
      let(:pbi) { described_class.create(product_id, content) }

      it 'id,product_id,内容を持つこと' do
        aggregate_failures do
          expect(pbi.id).to_not be_nil
          expect(pbi.product_id).to eq product_id
          expect(pbi.content).to eq content
        end
      end

      it 'サイズは不明であること' do
        expect(pbi.size).to eq StoryPoint.unknown
      end

      it '受け入れ基準は空であること' do
        expect(pbi.acceptance_criteria).to be_empty
      end
    end

    describe '#update_content' do
      let(:pbi) { described_class.create(product_id, content) }

      it do
        new_content = Content.new('NEW_CONTENT')
        pbi.update_content(new_content)

        expect(pbi.content).to eq(new_content)
      end
    end

    describe 'Status' do
      let(:pbi) { described_class.create(product_id, content) }

      it do
        expect(pbi.status).to eq Statuses::Preparation

        pbi.update_content(Content.new('NEW CONTENT'))
        expect(pbi.status).to eq Statuses::Preparation

        pbi.update_acceptance_criteria(acceptance_criteria(%w(AC1)))
        expect(pbi.status).to eq Statuses::Preparation

        pbi.estimate_size(StoryPoint.new(3))
        expect(pbi.status).to eq Statuses::Ready

        pbi.update_acceptance_criteria(acceptance_criteria(%w(AC1)))
        expect(pbi.status).to eq Statuses::Ready

        pbi.assign
        expect(pbi.status).to eq Statuses::Todo

        pbi.cancel_assignment
        expect(pbi.status).to eq Statuses::Ready
      end
    end
  end
end
