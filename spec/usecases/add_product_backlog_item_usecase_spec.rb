# typed: false
require 'rails_helper'

RSpec.describe AddProductBacklogItemUsecase do
  let!(:product) { create_product }
  let(:pbi_repo) { ProductBacklogItemRepository::AR }
  let(:order_repo) { ProductBacklogOrderRepository::AR }

  it '追加したPBIが保存されていること' do
    pbi_id = described_class.perform(product.id, Pbi::Content.new('aaa'))
    pbi = pbi_repo.find_by_id(pbi_id)

    aggregate_failures do
      expect(pbi.product_id).to eq product.id
      expect(pbi.status).to eq Pbi::Status::Preparation
      expect(pbi.content.to_s).to eq 'aaa'
      expect(pbi.size).to eq Pbi::StoryPoint.unknown
      expect(pbi.acceptance_criteria.to_a).to be_empty
    end
  end

  it '追加したPBIの優先順位は最低になっていること' do
    described_class.perform(product.id, Pbi::Content.new('aaa'))

    pbi_id = described_class.perform(product.id, Pbi::Content.new('bbb'))
    order = order_repo.find_by_product_id(product.id)

    expect(order.to_a.index(pbi_id)).to eq 1
  end
end
