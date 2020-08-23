# typed: false
require 'rails_helper'

RSpec.describe FeatureQuery do
  let!(:product) { create_product }

  it '着手可否を返すこと' do
    feature = add_feature(product.id, acceptance_criteria: %w(ac1), size: 1)

    stored = described_class.call(feature.id.to_s)
    expect(stored.status).to be_can_start_development
  end

  xit '着手取り下げ可否を返すこと' do
    feature = add_feature(product.id, acceptance_criteria: %w(ac1), size: 1)
    start_feature_development(feature.id)

    stored = described_class.call(feature.id.to_s)
    expect(stored.status).to be_can_abort_development
  end
end
