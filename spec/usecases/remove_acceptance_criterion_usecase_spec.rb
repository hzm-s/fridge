# typed: false
require 'rails_helper'

RSpec.describe RemoveAcceptanceCriterionUsecase do
  let!(:product) { create_product }
  let!(:issue) { plan_issue(product.id, acceptance_criteria: %w(AC1 AC2 AC3)) }
  let(:repository) { IssueRepository::AR }

  it do
    described_class.perform(issue.id, acceptance_criterion('AC2'))
    stored = repository.find_by_id(issue.id)

    expect(stored.acceptance_criteria).to eq acceptance_criteria(%w(AC1 AC3))
  end
end
