# typed: false
require 'rails_helper'

RSpec.describe AssignIssueToSprintUsecase do
  let!(:product) { create_product }
  let!(:issue_a) { plan_issue(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1) }
  let!(:issue_b) { plan_issue(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1) }
  let!(:issue_c) { plan_issue(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1) }
  let!(:roles) { team_roles(:po) }

  before do
    start_sprint(product.id)
  end

  it do
    described_class.perform(product.id, roles, issue_c.id)
    described_class.perform(product.id, roles, issue_a.id)
    described_class.perform(product.id, roles, issue_b.id)

    stored_sprint = SprintRepository::AR.current(product.id)
    stored_issue_a = IssueRepository::AR.find_by_id(issue_a.id)
    stored_issue_b = IssueRepository::AR.find_by_id(issue_b.id)
    stored_issue_c = IssueRepository::AR.find_by_id(issue_c.id)

    aggregate_failures do
      expect(stored_sprint.issues).to eq issue_list(issue_c.id, issue_a.id, issue_b.id)
      expect(stored_issue_a.status.to_s).to eq 'wip'
      expect(stored_issue_b.status.to_s).to eq 'wip'
      expect(stored_issue_c.status.to_s).to eq 'wip'
    end
  end

  it do
    SprintRepository::AR.current(product.id).tap do |sprint|
      sprint.finish
      SprintRepository::AR.store(sprint)
    end

    expect {
      described_class.perform(product.id, roles, issue_c.id)
    }.to raise_error Sprint::NotStarted
  end
end
