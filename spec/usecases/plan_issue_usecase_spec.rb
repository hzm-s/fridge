# typed: false
require 'rails_helper'

RSpec.describe PlanIssueUsecase do
  let!(:product) { create_product }

  before do
    append_release(product.id)
  end

  let(:description) { issue_description('ABC') }

  it do
    issue_id = described_class.perform(product.id, Issue::Types::Feature, description)

    issue = IssueRepository::AR.find_by_id(issue_id)
    plan = plan_of(product.id)

    aggregate_failures do
      expect(issue.product_id).to eq product.id
      expect(issue.type).to eq Issue::Types::Feature
      expect(issue.status).to eq Issue::Statuses::Preparation
      expect(issue.description).to eq description
      expect(issue.size).to eq Issue::StoryPoint.unknown
      expect(issue.acceptance_criteria).to be_empty

      expect(plan.release_of(1).issues).to eq issue_list(issue_id)
      expect(plan.release_of(2).issues).to eq issue_list
    end
  end

  context 'given release number' do
    it do
      issue_id = described_class.perform(product.id, Issue::Types::Feature, description, 2)

      issue = IssueRepository::AR.find_by_id(issue_id)
      plan = plan_of(product.id)

      aggregate_failures do
        expect(plan.release_of(1).issues).to eq issue_list
        expect(plan.release_of(2).issues).to eq issue_list(issue_id)
      end
    end
  end
end
