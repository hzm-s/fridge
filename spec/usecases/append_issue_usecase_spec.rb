# typed: false
require 'rails_helper'

RSpec.describe AppendIssueUsecase do
  let!(:product) { create_product }

  it do
    description = issue_description('ABC')

    issue_id = described_class.perform(product.id, Issue::Types::Feature, description)
    issue = IssueRepository::AR.find_by_id(issue_id)
    plan = PlanRepository::AR.find_by_product_id(product.id)

    aggregate_failures do
      expect(issue.product_id).to eq product.id
      expect(issue.type).to eq Issue::Types::Feature
      expect(issue.status).to eq Issue::Statuses::Preparation
      expect(issue.description).to eq description
      expect(issue.size).to eq Issue::StoryPoint.unknown
      expect(issue.acceptance_criteria).to be_empty

      expect(plan.pending).to eq Plan::IssueList.new([issue_id])
    end
  end
end
