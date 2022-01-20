# typed: false
require 'rails_helper'

describe ModifyReleaseTitleUsecase do
  let(:product) { create_product }
  let(:roles) { team_roles(:po) }

  it do
    described_class.perform(product.id, roles, 1, name('R1'))

    roadmap = RoadmapRepository::AR.find_by_product_id(product.id)

    aggregate_failures do
      expect(roadmap.release_of(1).title.to_s).to eq 'R1'
      expect(roadmap.release_of(1).items).to eq pbi_list
    end
  end
end
