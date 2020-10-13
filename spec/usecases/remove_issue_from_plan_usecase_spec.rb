# typed: false
require 'rails_helper'

RSpec.describe RemoveIssueFromPlanUsecase do
  let(:product) { create_product }
  let(:issue) { add_issue(product.id) }

  it do
    described_class.perform(product.id, issue.id)

    plan = PlanRepository::AR.find_by_product_id(product.id)

    expect(plan.order).to eq Plan::Order.new([])
  end
end
