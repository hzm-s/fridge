# typed: false
require 'rails_helper'

RSpec.describe FeatureQuery do
  let!(:product) { create_product }

  it '着手可否を返すこと' do
    feature = add_feature(product.id, acceptance_criteria: %w(ac1), size: 1)

    stored = described_class.call(feature.id.to_s)
    expect(stored.status).to be_can_assign
  end

  xit '着手取り下げ可否を返すこと' do
    feature = add_feature(product.id, acceptance_criteria: %w(ac1), size: 1)
    assign_feature(feature.id)

    stored = described_class.call(feature.id.to_s)
    expect(stored.status).to be_can_cancel_assignment
  end
end
