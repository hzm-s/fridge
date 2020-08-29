# typed: false
require 'rails_helper'

RSpec.describe PbiQuery do
  let!(:product) { create_product }

  it '着手可否を返すこと' do
    pbi = add_pbi(product.id, acceptance_criteria: %w(ac1), size: 1)

    stored = described_class.call(pbi.id.to_s)
    expect(stored.status).to be_can_start_development
  end

  it '着手取り下げ可否を返すこと' do
    pbi = add_pbi(product.id, acceptance_criteria: %w(ac1), size: 1)
    start_pbi_development(pbi.id)

    stored = described_class.call(pbi.id.to_s)
    expect(stored.status).to be_can_abort_development
  end
end
