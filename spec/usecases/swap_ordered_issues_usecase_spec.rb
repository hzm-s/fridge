# typed: false
require 'rails_helper'

RSpec.describe SwapOrderedIssuesUsecase do
  let(:product) { create_product }
  let!(:issue_a) { add_issue(product.id) }
  let!(:issue_b) { add_issue(product.id) }
  let!(:issue_c) { add_issue(product.id) }

  it do
    described_class.perform(product.id, issue_a.id, 2)

    plan = PlanRepository::AR.find_by_product_id(product.id)

    expect(plan.order).to eq Plan::Order.new([issue_b.id, issue_c.id, issue_a.id])
  end
end
