# typed: false
require 'rails_helper'

RSpec.describe RemoveAcceptanceCriterionUsecase do
  let!(:product) { create_product }
  let!(:pbi) { add_pbi(product.id, acceptance_criteria: %w(AC1 AC2 AC3)) }

  it do
    described_class.perform(pbi.id, 2)
    stored = PbiRepository::AR.find_by_id(pbi.id)

    expect(stored.acceptance_criteria.to_a).to eq %w(AC1 AC3)
  end
end
