# typed: false
require 'rails_helper'

RSpec.describe ModifyPbiUsecase do
  let!(:product) { create_product }

  it do
    pbi = add_pbi(product.id, 'ORIGINAL_CONTENT')

    described_class.perform(pbi.id, pbi_description('UPDATED_CONTENT'))

    updated = PbiRepository::AR.find_by_id(pbi.id)
    expect(updated.description.to_s).to eq 'UPDATED_CONTENT'
  end
end
