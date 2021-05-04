# typed: false
require 'rails_helper'

RSpec.describe AssignIssueToSprintUsecase do
  let!(:product) { create_product }
  let!(:issue) { plan_issue(product.id, acceptance_criteria: %w(AC1), size: 3, release: 1) }
  let!(:roles) { team_roles(:po) }

  before do
    start_sprint(product.id)
  end

  it do
    described_class.perform(product.id, roles, issue.id)

    assigned = IssueRepository::AR.find_by_id(issue.id)

    aggregate_failures do
      expect(assigned.status).to be Issue::Statuses::Wip
    end
  end
end
