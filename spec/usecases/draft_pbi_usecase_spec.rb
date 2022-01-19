# typed: false
require 'rails_helper'

describe DraftPbiUsecase do
  let!(:product) { create_product }

  before do
    append_release(product.id)
  end

  let(:description) { l_sentence('ABC') }

  it do
    pbi_id = described_class.perform(product.id, Pbi::Types.from_string('feature'), description)

    pbi = PbiRepository::AR.find_by_id(pbi_id)
    roadmap = roadmap_of(product.id)

    aggregate_failures do
      expect(pbi.product_id).to eq product.id
      expect(pbi.type).to eq Pbi::Types.from_string('feature')
      expect(pbi.status).to eq Pbi::Statuses.from_string('preparation')
      expect(pbi.description).to eq description
      expect(pbi.size).to eq Pbi::StoryPoint.unknown
      expect(pbi.acceptance_criteria).to be_empty

      expect(roadmap.release_of(1).items).to eq pbi_list(pbi_id)
      expect(roadmap.release_of(2).items).to eq pbi_list
    end
  end

  context 'given release number' do
    it do
      pbi_id = described_class.perform(product.id, Pbi::Types::Feature, description, 2)

      pbi = PbiRepository::AR.find_by_id(pbi_id)
      roadmap = roadmap_of(product.id)

      aggregate_failures do
        expect(roadmap.release_of(1).items).to eq pbi_list
        expect(roadmap.release_of(2).items).to eq pbi_list(pbi_id)
      end
    end
  end
end
