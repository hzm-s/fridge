# typed: false
require 'rails_helper'

RSpec.describe AcceptIssueUsecase do
  let!(:product) { create_product }
  let!(:issue) { plan_issue(product.id, acceptance_criteria: %w(CRT), size: 3, assign: true) }
  let!(:roles) { team_roles(:po) }

  xit do
    satisfy_acceptance_criteria(issue.id, [1])

    described_class.perform(roles, issue.id)
    stored = IssueRepository::AR.find_by_id(issue.id)

    aggregate_failures do
      expect(stored.status).to eq Issue::Statuses::Wip
      expect(stored).to be_accepted
    end
  end
end
