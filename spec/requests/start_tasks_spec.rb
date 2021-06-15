# typed: false
require 'rails_helper'

RSpec.describe '/work/:issue_id/start_tasks' do
  let!(:user_account) { sign_up }
  let!(:product) { create_product(person: user_account.person_id, roles: team_roles(:dev)) }
  let!(:issue) { plan_issue(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1) }

  before do
    sign_in(user_account)

    start_sprint(product.id)
    assign_issue_to_sprint(product.id, issue.id)
    plan_task(issue.id, %w(Task))
  end

  it do
    post work_start_tasks_path(issue_id: issue.id, number: 1, format: :js)
    get sprint_backlog_path(product.id)

    expect(response.body).to include %Q(test-task-status-#{issue.id}-1="wip")
  end
end
