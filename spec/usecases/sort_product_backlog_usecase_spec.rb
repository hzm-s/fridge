# typed: false
require 'rails_helper'

RSpec.describe SortProductBacklogUsecase do
  let!(:product) { create_product }
  let!(:pbi_a) { add_pbi(product.id, 'AAA').id }
  let!(:pbi_b) { add_pbi(product.id, 'BBB').id }
  let!(:pbi_c) { add_pbi(product.id, 'CCC').id }

  context 'same release' do
    it do
      described_class.perform(product.id, pbi_a, 1, 3)

      plan = PlanRepository::AR.find_by_product_id(product.id)
      expect(plan.items).to eq [[pbi_b, pbi_c, pbi_a]]
    end
  end

  context 'another release' do
    before do
      AddReleaseUsecase.perform(product.id, 'R2')
    end

    it do
      described_class.perform(product.id, pbi_b, 2, 1)

      plan = PlanRepository::AR.find_by_product_id(product.id)
      expect(plan.items).to eq [[pbi_a, pbi_c], [pbi_b]]
    end
  end
end
