# typed: false
require 'rails_helper'

RSpec.describe PlannedPbiQuery do
  let(:product) { create_product }
  let!(:pbi_a) { add_pbi(product.id, release: 1).id }
  let!(:pbi_b) { add_pbi(product.id, release: 1).id }
  let!(:pbi_c) { add_pbi(product.id, release: 2).id }
  let!(:pbi_d) { add_pbi(product.id, release: 3).id }
  let!(:pbi_e) { add_pbi(product.id, release: 3).id }

  it do
    plan = plan_of(product.id)

    query = described_class.new(plan)

    aggregate_failures do
      expect(query.call(1, 0)).to eq pbi_a
      expect(query.call(1, 1)).to eq pbi_b
      expect(query.call(1, 2)).to be_nil
      expect(query.call(2, 0)).to eq pbi_c
      expect(query.call(2, 2)).to be_nil
      expect(query.call(3, 0)).to eq pbi_d
      expect(query.call(3, 1)).to eq pbi_e
      expect(query.call(3, 2)).to be_nil
      expect(query.call(4, 0)).to be_nil
    end
  end
end
