# typed: false
require 'rails_helper'

describe PlannedPbiQuery do
  let(:product) { create_product }
  let!(:pbi_a) { add_pbi(product.id, release: 1).id }
  let!(:pbi_b) { add_pbi(product.id, release: 1).id }
  let!(:pbi_c) { add_pbi(product.id, release: 2).id }
  let!(:pbi_d) { add_pbi(product.id, release: 3).id }
  let!(:pbi_e) { add_pbi(product.id, release: 3).id }

  it do
    product_id = product.id.to_s
    aggregate_failures do
      expect(described_class.call(product_id, 1, 0)).to eq pbi_a
      expect(described_class.call(product_id, 1, 1)).to eq pbi_b
      expect(described_class.call(product_id, 1, 2)).to be_nil
      expect(described_class.call(product_id, 2, 0)).to eq pbi_c
      expect(described_class.call(product_id, 2, 2)).to be_nil
      expect(described_class.call(product_id, 3, 0)).to eq pbi_d
      expect(described_class.call(product_id, 3, 1)).to eq pbi_e
      expect(described_class.call(product_id, 3, 2)).to be_nil
      expect(described_class.call(product_id, 4, 0)).to be_nil
    end
  end
end
