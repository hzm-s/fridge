# typed: false
require 'rails_helper'

RSpec.describe AppendAcceptanceCriterionUsecase do
  let!(:product) { create_product }
  let!(:issue) { plan_issue(product.id) }

  it do
    described_class.perform(issue.id, acceptance_criterion('AC1'))
    stored = IssueRepository::AR.find_by_id(issue.id)
    expect(stored.acceptance_criteria).to eq acceptance_criteria(%w(AC1))

    described_class.perform(issue.id, acceptance_criterion('AC2'))
    described_class.perform(issue.id, acceptance_criterion('AC3'))
    stored = IssueRepository::AR.find_by_id(issue.id)
    expect(stored.acceptance_criteria).to eq acceptance_criteria(%w(AC1 AC2 AC3))
  end
end
