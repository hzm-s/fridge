# typed: false
require 'rails_helper'

RSpec.describe SprintBacklogQuery do
  let!(:product) { create_product }
  let!(:issue_a) { plan_issue(product.id, acceptance_criteria: %w(CRT_A), size: 3, release: 1) }
  let!(:issue_b) { plan_issue(product.id, acceptance_criteria: %w(CRT_B), size: 3, release: 1) }
  let!(:issue_c) { plan_issue(product.id, acceptance_criteria: %w(CRT_C), size: 3, release: 1) }
  let!(:sprint) { start_sprint(product.id) }

  before do
    assign_issue_to_sprint(product.id, issue_c.id, sprint)
    assign_issue_to_sprint(product.id, issue_a.id, sprint)
    assign_issue_to_sprint(product.id, issue_b.id, sprint)
  end

  it do
    sbl = described_class.call(sprint.id)
    expect(sbl.issues.map(&:id)).to eq [issue_c, issue_a, issue_b].map(&:id).map(&:to_s)
  end

  it do
    sbl = described_class.call(sprint.id)
    issue = sbl.issues.first
    expect(issue.criteria.first.content).to eq 'CRT_C'
  end
end
