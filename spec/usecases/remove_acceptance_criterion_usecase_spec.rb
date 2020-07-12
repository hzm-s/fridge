require 'rails_helper'

RSpec.describe 'Remove acceptance criterion' do
  let!(:product) { create_product }
  let!(:pbi) { add_pbi(product.id) }

  it do
    add_acceptance_criteria(pbi, %w(ac1 ac2 ac3))

    RemoveAcceptanceCriterionUsecase.new.perform(pbi.id, 2)
    updated = ProductBacklogItemRepository::AR.find_by_id(pbi.id)

    expect(updated.acceptance_criteria.to_a).to match_array %w(ac1 ac3)
  end
end
