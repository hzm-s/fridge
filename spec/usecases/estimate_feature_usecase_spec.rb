# typed: false
require 'rails_helper'

RSpec.describe EstimateFeatureUsecase do
  let!(:product) { create_product }
  let(:roles) { team_roles(:dev) }

  it do
    feature = plan_issue(product.id, 'ABC', type: :feature)

    point = Issue::StoryPoint.new(8)
    id = described_class.perform(feature.id, roles, point)

    stored = IssueRepository::AR.find_by_id(id)
    expect(stored.size).to eq point
  end
end
