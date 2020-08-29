# typed: false
require 'rails_helper'

RSpec.describe RemoveAcceptanceCriterionUsecase do
  let!(:product) { create_product }
  let!(:pbi) { add_pbi(product.id, acceptance_criteria: %w(AC1 AC2 AC3)) }
  let(:repository) { PbiRepository::AR }

  it do
    described_class.perform(pbi.id, acceptance_criterion('AC2'))
    updated = repository.find_by_id(pbi.id)

    expect(updated.acceptance_criteria).to eq acceptance_criteria(%w(AC1 AC3))
  end
end
