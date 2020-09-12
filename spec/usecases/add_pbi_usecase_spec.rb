# typed: false
require 'rails_helper'

RSpec.describe AddPbiUsecase do
  let!(:product) { create_product }

  it do
    description = pbi_description('ABC')

    pbi_id = described_class.perform(product.id, description)
    pbi = PbiRepository::AR.find_by_id(pbi_id)

    aggregate_failures do
      expect(pbi.product_id).to eq product.id
      expect(pbi.status).to eq Pbi::Statuses::Preparation
      expect(pbi.description).to eq description
      expect(pbi.size).to eq Pbi::StoryPoint.unknown
      expect(pbi.acceptance_criteria).to be_empty
    end
  end
end
