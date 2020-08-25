# typed: false
require 'rails_helper'

RSpec.describe EstimateFeatureUsecase do
  let!(:product) { create_product }

  it do
    feature = add_feature(product.id, 'ABC')

    point = Feature::StoryPoint.new(8)
    id = described_class.perform(feature.id, point)

    stored = FeatureRepository::AR.find_by_id(id)
    expect(stored.size).to eq point
  end
end