# typed: false
require 'rails_helper'

RSpec.describe AddAcceptanceCriterionUsecase do
  let!(:product) { create_product }
  let!(:pbi) { add_pbi(product.id) }

  it do
    described_class.perform(pbi.id, acceptance_criterion('AC1'))
    updated = ProductBacklogItemRepository::AR.find_by_id(pbi.id)
    expect(updated.acceptance_criteria).to eq acceptance_criteria(%w(AC1))

    described_class.perform(pbi.id, acceptance_criterion('AC2'))
    described_class.perform(pbi.id, acceptance_criterion('AC3'))
    updated = ProductBacklogItemRepository::AR.find_by_id(pbi.id)
    expect(updated.acceptance_criteria).to eq acceptance_criteria(%w(AC1 AC2 AC3))
  end
end
