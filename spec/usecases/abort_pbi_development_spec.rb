# typed: false
require 'rails_helper'

RSpec.describe AbortPbiDevelopmentUsecase do
  let(:product) { create_product }
  let!(:pbi) { add_pbi(product.id, acceptance_criteria: %w(ac1), size: 8) }

  it do
    start_pbi_development(pbi.id)

    described_class.perform(pbi.id)
    updated = PbiRepository::AR.find_by_id(pbi.id)

    expect(updated.status).to eq Pbi::Statuses::Ready
  end
end
