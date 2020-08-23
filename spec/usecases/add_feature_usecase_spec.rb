# typed: false
require 'rails_helper'

RSpec.describe AddFeatureUsecase do
  let!(:product) { create_product }
  let(:feature_repo) { FeatureRepository::AR }
  let(:pbl_repo) { ProductBacklogRepository::AR }

  it '追加したフィーチャーが保存されていること' do
    description = feature_description('ABC')
    feature_id = described_class.perform(product.id, description)
    feature = feature_repo.find_by_id(feature_id)

    aggregate_failures do
      expect(feature.product_id).to eq product.id
      expect(feature.status).to eq Feature::Statuses::Preparation
      expect(feature.description).to eq description
      expect(feature.size).to eq Feature::StoryPoint.unknown
      expect(feature.acceptance_criteria).to be_empty
    end
  end

  it '追加したフィーチャーの優先順位は最低になっていること' do
    base_item = described_class.perform(product.id, feature_description('aaa'))

    new_item = described_class.perform(product.id, feature_description('bbb'))
    pbl = pbl_repo.find_by_product_id(product.id)

    expect(pbl.items).to eq [base_item, new_item]
  end
end
