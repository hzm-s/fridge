# typed: false
require 'rails_helper'

RSpec.describe AddPbiUsecase do
  let!(:product) { create_product }
  let(:pbi_repo) { PbiRepository::AR }
  let(:plan_repo) { PlanRepository::AR }

  it '追加したアイテムが保存されていること' do
    description = pbi_description('ABC')
    pbi_id = described_class.perform(product.id, description)
    pbi = pbi_repo.find_by_id(pbi_id)

    aggregate_failures do
      expect(pbi.product_id).to eq product.id
      expect(pbi.status).to eq Pbi::Statuses::Preparation
      expect(pbi.description).to eq description
      expect(pbi.size).to eq Pbi::StoryPoint.unknown
      expect(pbi.acceptance_criteria).to be_empty
    end
  end

  it '追加したフィーチャーの優先順位は最低になっていること' do
    base_item = described_class.perform(product.id, pbi_description('aaa'))

    new_item = described_class.perform(product.id, pbi_description('bbb'))
    plan = plan_repo.find_by_product_id(product.id)

    expect(plan.release(1).items).to eq [base_item, new_item]
  end
end
