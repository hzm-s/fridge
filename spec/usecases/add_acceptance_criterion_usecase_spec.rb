# typed: false
require 'rails_helper'

RSpec.describe AddAcceptanceCriterionUsecase do
  let!(:user) { register_user }
  let!(:product) { create_product(user_id: user.id) }
  let!(:pbi) { add_pbi(product.id) }

  it do
    described_class.perform(pbi.id, 'ukeire_kijyun_ichi')

    updated = ProductBacklogItemRepository::AR.find_by_id(pbi.id)

    expect(updated.acceptance_criteria.to_a).to eq [{no: 1, content: 'ukeire_kijyun_ichi'}]
  end
end
