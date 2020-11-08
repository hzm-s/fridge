# typed: false
require 'rails_helper'

RSpec.describe SpecifyReleaseUsecase do
  let(:product) { create_product }
  let!(:issue_a) { add_issue(product.id) }
  let!(:issue_b) { add_issue(product.id) }
  let!(:issue_c) { add_issue(product.id) }

  it do
    described_class.perform(product.id, 'MVP', issue_b.id)

    plan = PlanRepository::AR.find_by_product_id(product.id)

    expect(plan.scoped).to eq [Plan::Release.new('MVP', [issue_a.id, issue_b.id])]
    expect(plan.unscoped).to eq [issue_c.id]
  end
end
