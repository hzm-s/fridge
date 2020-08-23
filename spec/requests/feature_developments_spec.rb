# typed: false
require 'rails_helper'

RSpec.describe 'feature_developments' do
  let(:product) { create_product }
  let!(:feature) { add_feature(product.id, acceptance_criteria: %w(ac1), size: 2) }

  describe '#create' do
    it do
      expect {
        post feature_developments_path(id: feature.id.to_s, format: :js)
      }
        .to change { Dao::Feature.find(feature.id.to_s).status }
        .from(Feature::Statuses::Ready.to_s)
        .to(Feature::Statuses::Wip.to_s)
    end

    it do
      post feature_developments_path(id: feature.id.to_s, format: :js)
      expect(response.body).to include 'wip'
    end
  end

  describe '#destroy' do
    before do
      start_feature_development(feature.id)
    end

    it do
      expect {
        delete feature_development_path(feature.id.to_s, format: :js)
      }
        .to change { Dao::Feature.find(feature.id.to_s).status }
        .from(Feature::Statuses::Wip.to_s)
        .to(Feature::Statuses::Ready.to_s)
    end

    it do
      delete feature_development_path(feature.id.to_s, format: :js)
      expect(response.body).to include 'ready'
    end
  end
end
