# typed: false
require 'rails_helper'

RSpec.describe SortProductBacklogUsecase do
  let!(:product) { create_product }
  let!(:pbi_a) { add_pbi(product.id).id }
  let!(:pbi_b) { add_pbi(product.id).id }
  let!(:pbi_c) { add_pbi(product.id).id }

  context 'same release' do
    it do
      described_class.perform(product.id, 1, pbi_a, 1, 3)

      plan = PlanRepository::AR.find_by_product_id(product.id)
      release = plan.release(1)
      expect(release.items).to eq [pbi_b, pbi_c, pbi_a]
    end
  end

  context 'another release' do
    it do
      add_release(product.id, 'R2')

      described_class.perform(product.id, 1, pbi_b, 2, 1)

      plan = PlanRepository::AR.find_by_product_id(product.id)
      src = plan.release(1)
      dst = plan.release(2)

      expect(src.items).to eq [pbi_a, pbi_c]
      expect(dst.items).to eq [pbi_b]
    end
  end
end
