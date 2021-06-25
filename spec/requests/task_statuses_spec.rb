# typed: false
require 'rails_helper'

RSpec.describe '/work/:issue_id/task_statuses' do
  let!(:user_account) { sign_up }
  let!(:product) { create_product(person: user_account.person_id, roles: team_roles(:dev)) }
  let!(:issue) { plan_issue(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1) }

  before do
    sign_in(user_account)

    start_sprint(product.id)
    assign_issue_to_sprint(product.id, issue.id)
    plan_task(issue.id, %w(Task))
  end

  describe 'Start' do
    it do
      patch work_task_status_path(issue_id: issue.id, number: 1, type: :start, format: :js)
      expect(response.body).to include %Q(test-task-status-#{issue.id}-1=\\"wip\\")
    end
  end

  describe 'Suspend' do
    before { start_task(issue.id, 1) }

    it do
      patch work_task_status_path(issue_id: issue.id, number: 1, type: :suspend, format: :js)
      expect(response.body).to include %Q(test-task-status-#{issue.id}-1=\\"wait\\")
    end
  end

  describe 'Resume' do
    before do
      start_task(issue.id, 1)
      suspend_task(issue.id, 1)
    end

    it do
      patch work_task_status_path(issue_id: issue.id, number: 1, type: :resume, format: :js)
      expect(response.body).to include %Q(test-task-status-#{issue.id}-1=\\"wip\\")
    end
  end

  describe 'Complete' do
    before { start_task(issue.id, 1) }

    it do
      patch work_task_status_path(issue_id: issue.id, number: 1, type: :complete, format: :js)
      expect(response.body).to include %Q(test-task-status-#{issue.id}-1=\\"done\\")
    end
  end
end
