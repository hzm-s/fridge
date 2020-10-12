# typed: false
require 'rails_helper'

RSpec.describe AppendIssueToPlanUsecase do
  let(:product) { create_product }
  let(:issue) { Issue::Issue.create(product.id, Issue::Types::Feature, issue_description('DESC')) }

  it do
    described_class.perform(product.id, issue.id)

    plan = PlanRepository::AR.find_by_product_id(product.id)

    expect(plan.issues).to eq Plan::Order.new([issue.id])
  end
end
