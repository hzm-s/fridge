# typed: false
require 'rails_helper'

RSpec.describe PlanIssueUsecase do
  let(:product) { create_product }
  let(:issue) { Issue::Issue.create(product.id, Issue::Types::Feature, issue_description('DESC')) }

  it do
    described_class.perform(product.id, issue.id)

    plan = PlanRepository::AR.find_by_product_id(product.id)

    expect(plan.pending).to eq Plan::IssueList.new([issue.id])
  end
end
