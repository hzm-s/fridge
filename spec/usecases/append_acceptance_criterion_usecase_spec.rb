# typed: false
require 'rails_helper'

RSpec.describe AppendAcceptanceCriterionUsecase do
  let!(:product) { create_product }
  let!(:issue) { plan_issue(product.id) }

  it do
    described_class.perform(issue.id, s_sentence('AC1'))
    stored = IssueRepository::AR.find_by_id(issue.id)
    expect(stored.acceptance_criteria.of(1).content.to_s).to eq 'AC1'

    described_class.perform(issue.id, s_sentence('AC2'))
    described_class.perform(issue.id, s_sentence('AC3'))
    stored = IssueRepository::AR.find_by_id(issue.id)
    expect(stored.acceptance_criteria.of(2).content.to_s).to eq 'AC2'
    expect(stored.acceptance_criteria.of(3).content.to_s).to eq 'AC3'
  end
end
