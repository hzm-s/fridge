# typed: false
require 'rails_helper'

describe AppendAcceptanceCriterionUsecase do
  let!(:product) { create_product }
  let!(:pbi) { add_pbi(product.id) }

  it do
    described_class.perform(pbi.id, s_sentence('AC1'))
    described_class.perform(pbi.id, s_sentence('AC2'))
    described_class.perform(pbi.id, s_sentence('AC3'))

    stored = PbiRepository::AR.find_by_id(pbi.id)

    expect(stored.acceptance_criteria.to_a).to eq %w(AC1 AC2 AC3)
  end
end
