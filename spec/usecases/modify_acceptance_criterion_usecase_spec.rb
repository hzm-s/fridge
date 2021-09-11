# typed: false
require 'rails_helper'

RSpec.describe ModifyAcceptanceCriterionUsecase do
  let!(:product) { create_product }
  let!(:issue) { plan_issue(product.id, acceptance_criteria: %w(AC1 AC2 AC3)) }

  it do
    described_class.perform(issue.id, 2, s_sentence('Modified AC2'))
    stored = IssueRepository::AR.find_by_id(issue.id)

    aggregate_failures do
      expect(stored.acceptance_criteria.of(1).content.to_s).to eq 'AC1'
      expect(stored.acceptance_criteria.of(2).content.to_s).to eq 'Modified AC2'
      expect(stored.acceptance_criteria.of(3).content.to_s).to eq 'AC3'
    end
  end
end
