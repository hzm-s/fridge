# typed: false
require 'rails_helper'

RSpec.describe '/work/:issue_id/complete_tasks' do
  let!(:user_account) { sign_up }
  let!(:product) { create_product(person: user_account.person_id, roles: team_roles(:dev)) }
  let!(:issue) { plan_issue(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1) }

  before do
    sign_in(user_account)

    start_sprint(product.id)
    assign_issue_to_sprint(product.id, issue.id)
    plan_task(issue.id, %w(Task))
    start_task(issue.id, 1)
  end

  it do
    post work_complete_tasks_path(issue_id: issue.id, number: 1, format: :js)
    expect(response.body).to include %Q(test-task-status-#{issue.id}-1=\\"done\\")
  end
end
