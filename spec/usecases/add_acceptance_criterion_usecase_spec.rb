# typed: false
require 'rails_helper'

RSpec.describe AddAcceptanceCriterionUsecase do
  let!(:product) { create_product }
  let!(:pbi) { add_pbi(product.id) }

  it do
    ac1 = Pbi::AcceptanceCriterion.new('AC1')
    described_class.perform(pbi.id, ac1)
    updated = ProductBacklogItemRepository::AR.find_by_id(pbi.id)
    expect(updated.acceptance_criteria).to eq [ac1]

    ac2 = Pbi::AcceptanceCriterion.new('AC2')
    described_class.perform(pbi.id, ac2)
    updated = ProductBacklogItemRepository::AR.find_by_id(pbi.id)
    expect(updated.acceptance_criteria).to eq [ac1, ac2]
  end
end
