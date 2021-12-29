# typed: false
require 'rails_helper'

describe DissatisfyAcceptanceCriterionUsecase do
  let!(:product) { create_product }
  let!(:issue) { plan_issue(product.id, acceptance_criteria: %w(AC1 AC2 AC3), size: 3, assign: true) }
  let!(:roles) { team_roles(:po) }

  it do
    satisfy_acceptance_criteria(issue.id, [1, 2, 3])

    described_class.perform(roles, issue.id, 2)
    work = WorkRepository::AR.find_by_issue_id(issue.id)

    expect(work.acceptance.satisfied_criteria).to eq [1, 3].to_set
  end
end
