# typed: false
require 'rails_helper'

describe AppendReleaseUsecase do
  let(:product) { create_product }
  let(:roles) { team_roles(:po) }

  it do
    described_class.perform(roles, product.id, name('MVP'))

    roadmap = RoadmapRepository::AR.find_by_product_id(product.id)

    aggregate_failures do
      expect(roadmap.release_of(2).title.to_s).to eq 'MVP'
      expect(roadmap.release_of(2).items).to eq pbi_list
    end
  end

  it do
    described_class.perform(roles, product.id, nil)

    roadmap = RoadmapRepository::AR.find_by_product_id(product.id)

    expect(roadmap.release_of(2).title.to_s).to eq 'Release#2'
  end
end
