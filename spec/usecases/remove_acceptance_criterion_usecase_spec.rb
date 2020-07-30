# typed: false
require 'rails_helper'

RSpec.describe RemoveAcceptanceCriterionUsecase do
  let!(:product) { create_product }
  let!(:pbi) { add_pbi(product.id) }
  let(:repository) { ProductBacklogItemRepository::AR }

  it do
    ac1 = Pbi::AcceptanceCriterion.new('AC1')
    ac2 = Pbi::AcceptanceCriterion.new('AC2')
    ac3 = Pbi::AcceptanceCriterion.new('AC3')
    add_acceptance_criteria(pbi, [ac1, ac2, ac3])

    described_class.perform(pbi.id, ac2)
    updated = repository.find_by_id(pbi.id)

    expect(updated.acceptance_criteria).to eq [ac1, ac3]
  end
end
