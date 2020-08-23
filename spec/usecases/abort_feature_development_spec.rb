# typed: false
require 'rails_helper'

RSpec.describe AbortFeatureDevelopmentUsecase do
  let(:product) { create_product }
  let!(:feature) { add_feature(product.id, acceptance_criteria: %w(ac1), size: 8) }

  it do
    start_feature_development(feature.id)

    described_class.perform(feature.id)
    updated = FeatureRepository::AR.find_by_id(feature.id)

    expect(updated.status).to eq Feature::Statuses::Ready
  end
end
