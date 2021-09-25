# typed: false
require 'rails_helper'

RSpec.xdescribe SatisfyAcceptanceCriterionUsecase do
  let!(:product) { create_product }
  let!(:issue) { plan_issue(product.id, acceptance_criteria: %w(AC1 AC2 AC3), size: 3, assign: true) }
  let!(:roles) { team_roles(:po) }

  it do
    described_class.perform(roles, issue.id, 2)
    stored = IssueRepository::AR.find_by_id(issue.id)

    aggregate_failures do
      expect(stored.acceptance_criteria.of(1)).to_not be_satisfied 
      expect(stored.acceptance_criteria.of(2)).to be_satisfied
      expect(stored.acceptance_criteria.of(3)).to_not be_satisfied 
    end
  end
end
