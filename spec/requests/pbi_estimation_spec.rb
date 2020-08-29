# typed: false
require 'rails_helper'

RSpec.describe 'feature_estimation' do
  let!(:user_account) { sign_up }
  let!(:product) { create_product(person_id: user_account.person_id) }
  let!(:feature) { add_feature(product.id) }

  describe '#update' do
    it do
      put feature_estimation_path(feature.id, format: :js), params: { form: { point: '8' } }

      updated = FeatureRepository::AR.find_by_id(feature.id)
      expect(updated.size.to_i).to eq 8
    end

    it do
      put feature_estimation_path(feature.id, format: :js), params: { form: { point: '?' } }

      updated = FeatureRepository::AR.find_by_id(feature.id)
      expect(updated.size.to_i).to eq nil 
    end
  end
end
