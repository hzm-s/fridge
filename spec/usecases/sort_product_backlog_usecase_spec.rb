# typed: false
require 'rails_helper'

RSpec.xdescribe SortProductBacklogUsecase do
  let!(:product) { create_product }
  let!(:pbi_a) { add_pbi(product.id, 'AAA').id }
  let!(:pbi_b) { add_pbi(product.id, 'BBB').id }
  let!(:pbi_c) { add_pbi(product.id, 'CCC').id }

  context 'same release' do
    it do
      release = ReleaseRepository::AR.find_last_by_product_id(product.id)

      described_class.perform(product.id, release.id, pbi_a, release.id, 3)

      stored = ReleaseRepository::AR.find_by_id(release.id)
      expect(stored.items).to eq [pbi_b, pbi_c, pbi_a]
    end
  end

  context 'another release' do
    it do
      from = ReleaseRepository::AR.find_last_by_product_id(product.id)
      to = add_release(product.id, 'R2')

      described_class.perform(product.id, from.id, pbi_b, to.id, 1)

      stored_from = ReleaseRepository::AR.find_by_id(from.id)
      stored_to = ReleaseRepository::AR.find_by_id(to.id)
      expect(stored_from.items).to eq [pbi_a, pbi_c]
      expect(stored_to.items).to eq [pbi_b]
    end
  end
end
