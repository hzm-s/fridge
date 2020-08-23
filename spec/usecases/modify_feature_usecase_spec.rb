# typed: false
require 'rails_helper'

RSpec.describe ModifyFeatureUsecase do
  let!(:product) { create_product }

  it do
    feature = add_feature(product.id, 'ORIGINAL_CONTENT')

    described_class.perform(feature.id, feature_description('UPDATED_CONTENT'))

    updated = FeatureRepository::AR.find_by_id(feature.id)
    expect(updated.description.to_s).to eq 'UPDATED_CONTENT'
  end
end
