# typed: false
require 'rails_helper'

describe CreateProductUsecase do
  it do
    product_id = described_class.perform(name('abc'), s_sentence('xyz'))

    product = ProductRepository::AR.find_by_id(product_id)
    roadmap = RoadmapRepository::AR.find_by_product_id(product_id)

    aggregate_failures do
      expect(product.name.to_s).to eq 'abc'
      expect(product.description.to_s).to eq 'xyz'

      expect(roadmap.recent_release.number).to eq 1
      expect(roadmap.recent_release.title.to_s).to eq 'Release#1'
      expect(roadmap.recent_release.items).to eq pbi_list
    end
  end
end
