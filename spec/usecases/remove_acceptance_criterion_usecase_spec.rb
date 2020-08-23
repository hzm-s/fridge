# typed: false
require 'rails_helper'

RSpec.describe RemoveAcceptanceCriterionUsecase do
  let!(:product) { create_product }
  let!(:feature) { add_feature(product.id, acceptance_criteria: %w(AC1 AC2 AC3)) }
  let(:repository) { FeatureRepository::AR }

  it do
    described_class.perform(feature.id, acceptance_criterion('AC2'))
    updated = repository.find_by_id(feature.id)

    expect(updated.acceptance_criteria).to eq acceptance_criteria(%w(AC1 AC3))
  end
end
