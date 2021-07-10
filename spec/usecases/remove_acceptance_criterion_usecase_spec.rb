# typed: false
require 'rails_helper'

RSpec.describe RemoveAcceptanceCriterionUsecase do
  let!(:product) { create_product }
  let!(:issue) { plan_issue(product.id, acceptance_criteria: %w(AC1 AC2 AC3)) }

  it do
    described_class.perform(issue.id, 2)
    stored = IssueRepository::AR.find_by_id(issue.id)

    aggregate_failures do
      expect(stored.acceptance_criteria.of(1).content).to eq 'AC1'
      expect(stored.acceptance_criteria.of(2)).to be_nil
      expect(stored.acceptance_criteria.of(3).content).to eq 'AC3'
    end
  end
end
