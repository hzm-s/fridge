# typed: false
require 'rails_helper'

xdescribe AcceptWorkUsecase do
  let!(:product) { create_product }
  let!(:issue) { plan_issue(product.id, acceptance_criteria: %w(CRT), size: 3, assign: true) }
  let!(:roles) { team_roles(:po) }

  it do
    satisfy_acceptance_criteria(issue.id, [1])

    described_class.perform(roles, issue.id)
    work = WorkRepository::AR.find_by_issue_id(issue.id)

    expect(work.status).to eq Work::Statuses.from_string('accepted')
  end
end
