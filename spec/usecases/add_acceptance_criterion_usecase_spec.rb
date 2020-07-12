require 'rails_helper'

RSpec.describe 'Add acceptance criterion to PBI' do
  let!(:product) { create_product }
  let!(:pbi) { add_pbi(product.id) }

  it do
    uc = AddAcceptanceCriterionUsecase.new
    uc.perform(pbi.id, 'ukeire_kijyun_ichi')

    updated = ProductBacklogItemRepository::AR.find_by_id(pbi.id)

    expect(updated.acceptance_criteria.to_a).to eq %w(ukeire_kijyun_ichi)
  end
end
