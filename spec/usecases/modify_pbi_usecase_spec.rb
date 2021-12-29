# typed: false
require 'rails_helper'

describe ModifyPbiUsecase do
  let!(:product) { create_product }

  it do
    pbi = add_pbi(product.id, 'ORIGINAL_DESCRIPTION')

    described_class.perform(pbi.id, l_sentence('NEW_DESCRIPTION'))

    stored = PbiRepository::AR.find_by_id(pbi.id)
    expect(stored.description.to_s).to eq 'NEW_DESCRIPTION'
  end
end
