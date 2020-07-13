require 'rails_helper'

RSpec.describe 'Remove acceptance criterion' do
  let!(:product) { create_product }
  let!(:pbi) { add_pbi(product.id) }
  let(:usecase) { RemoveAcceptanceCriterionUsecase.new }
  let(:repository) { ProductBacklogItemRepository::AR }

  it do
    add_acceptance_criteria(pbi, %w(ac1 ac2 ac3))

    usecase.perform(pbi.id, 2)
    updated = repository.find_by_id(pbi.id)

    expect(updated.acceptance_criteria.to_a).to eq [
      { no: 1, content: 'ac1' },
      { no: 3, content: 'ac3' },
    ]
  end

  it do
    add_acceptance_criteria(pbi, %w(ac1 ac2 ac3))
    usecase.perform(pbi.id, 3)
    add_acceptance_criteria(pbi, %w(ac4))

    expect { usecase.perform(pbi.id, 3) }.to raise_error(ArgumentError)
  end
end
