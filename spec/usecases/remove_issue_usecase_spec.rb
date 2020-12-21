# typed: false
require 'rails_helper'

RSpec.describe RemoveIssueUsecase do
  let!(:product) { create_product }

  it do
    issue = add_issue(product.id)
    described_class.perform(issue.id)

    plan = PlanRepository::AR.find_by_product_id(product.id)

    aggregate_failures do
      expect(Dao::Issue.find_by(id: issue.id.to_s)).to be_nil
      expect(plan.pending).to eq Plan::IssueList.new
      expect(plan.scheduled).to eq Plan::ReleaseList.new
    end
  end
end
