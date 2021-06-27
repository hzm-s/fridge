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
      patch work_task_status_path(issue_id: issue.id, number: 1, type: :start_task, format: :js)
      expect(response.body).to include %Q(test-task-status-#{issue.id}-1=\\"wip\\")
    end
  end

  describe 'Suspend' do
    before { start_task(issue.id, 1) }

    it do
      patch work_task_status_path(issue_id: issue.id, number: 1, type: :suspend_task, format: :js)
      expect(response.body).to include %Q(test-task-status-#{issue.id}-1=\\"wait\\")
    end
  end

  describe 'Resume' do
    before do
      start_task(issue.id, 1)
      suspend_task(issue.id, 1)
    end

    it do
      patch work_task_status_path(issue_id: issue.id, number: 1, type: :resume_task, format: :js)
      expect(response.body).to include %Q(test-task-status-#{issue.id}-1=\\"wip\\")
    end
  end

  describe 'Complete' do
    before { start_task(issue.id, 1) }

    it do
      patch work_task_status_path(issue_id: issue.id, number: 1, type: :complete_task, format: :js)
      expect(response.body).to include %Q(test-task-status-#{issue.id}-1=\\"done\\")
    end
  end

  describe 'Available actions' do
    subject do
      get sprint_backlog_path(product.id)
      response.body
    end

    context 'when Todo' do
      it do
        aggregate_failures do
          expect(subject).to include %Q(test-start-task-#{issue.id}-1)
          expect(subject).to_not include %Q(test-complete-task-#{issue.id}-1)
          expect(subject).to_not include %Q(test-suspend-task-#{issue.id}-1)
          expect(subject).to_not include %Q(test-resume-task-#{issue.id}-1)
        end
      end
    end

    context 'when Wip' do
      it do
        start_task(issue.id, 1)
        aggregate_failures do
          expect(subject).to_not include %Q(test-start-task-#{issue.id}-1)
          expect(subject).to include %Q(test-complete-task-#{issue.id}-1)
          expect(subject).to include %Q(test-suspend-task-#{issue.id}-1)
          expect(subject).to_not include %Q(test-resume-task-#{issue.id}-1)
        end
      end
    end
  end
end
