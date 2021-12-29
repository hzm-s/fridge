# typed: false
require 'rails_helper'

describe PbiQuery do
  let!(:product) { create_product }
  let(:pbi) { add_pbi(product.id, acceptance_criteria: %w(ac1)) }

  it do
    stored = described_class.call(pbi.id.to_s)

    aggregate_failures do
      expect(stored.product_id).to eq pbi.product_id.to_s
      expect(stored.type).to eq pbi.type
      expect(stored.status).to eq pbi.status
    end
  end
end
