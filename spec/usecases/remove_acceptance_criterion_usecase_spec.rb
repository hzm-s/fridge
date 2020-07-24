# typed: false
require 'rails_helper'

RSpec.describe RemoveAcceptanceCriterionUsecase do
  let!(:product) { create_product }
  let!(:pbi) { add_pbi(product.id) }
  let(:repository) { ProductBacklogItemRepository::AR }

  it do
    add_acceptance_criteria(pbi, %w(ac1 ac2 ac3))

    described_class.perform(pbi.id, 2)
    updated = repository.find_by_id(pbi.id)

    expect(updated.acceptance_criteria.to_a).to eq [
      { no: 1, content: 'ac1' },
      { no: 3, content: 'ac3' },
    ]
  end

  it do
    add_acceptance_criteria(pbi, %w(ac1 ac2 ac3))
    described_class.perform(pbi.id, 3)
    add_acceptance_criteria(pbi, %w(ac4))

    expect { described_class.perform(pbi.id, 3) }.to raise_error(ArgumentError)
  end
end
