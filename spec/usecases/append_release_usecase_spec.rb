# typed: false
require 'rails_helper'

RSpec.describe AppendReleaseUsecase do
  let(:product) { create_product }

  it do
    described_class.perform(product.id, 'MVP')

    plan = PlanRepository::AR.find_by_product_id(product.id)

    expect(plan.scoped).to eq Plan::ReleaseList.new([
      Plan::Release.new('MVP', Plan::IssueList.new)
    ])
    expect(plan.not_scoped).to eq Plan::IssueList.new
  end
end
