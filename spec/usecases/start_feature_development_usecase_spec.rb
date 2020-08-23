# typed: false
require 'rails_helper'

RSpec.describe StartFeatureDevelopmentUsecase do
  let(:product) { create_product }
  let(:feature) { add_feature(product.id, acceptance_criteria: %w(ac1), size: 3) }

  it do
    described_class.perform(feature.id)
    updated = FeatureRepository::AR.find_by_id(feature.id)
    expect(updated.status).to eq Feature::Statuses::Wip
  end
end
