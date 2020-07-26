# typed: false
require 'rails_helper'

module Pbi::Statuses
  RSpec.describe Draft do
    let!(:product_id) { Product::Id.create }
    let!(:pbi) { Pbi::Item.create(product_id, Pbi::Content.new('content')) }

    context '大きさが不明な場合' do
      context '受け入れ基準が0件の場合' do
        it do
          status = described_class.update_by(pbi)
          expect(status).to eq Draft
        end
      end

      context '受け入れ基準が1件以上ある場合' do
        it do
          pbi.add_acceptance_criterion('ac')
          status = described_class.update_by(pbi)
          expect(status).to eq Draft
        end
      end
    end

    context '大きさが見積もり済みの場合' do
      before do
        pbi.estimate_size(Pbi::StoryPoint.new(3))
      end

      context '受け入れ基準が0件の場合' do
        it do
          status = described_class.update_by(pbi)
          expect(status).to eq Draft
        end
      end

      context '受け入れ基準が1件以上ある場合' do
        it do
          pbi.add_acceptance_criterion('ac')
          status = described_class.update_by(pbi)
          expect(status).to eq Preparation
        end
      end
    end
  end
end
