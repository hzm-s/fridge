# typed: false
require 'rails_helper'

RSpec.describe '/work/:issue_id/tasks' do
  let!(:user_account) { sign_up }
  let!(:product) { create_product(person: user_account.person_id, roles: team_roles(:dev)) }
  let!(:issue) { plan_issue(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1, assign: true) }

  before do
    sign_in(user_account)
  end

  describe 'create' do
    context 'given valid params' do
      it do
        post work_tasks_path(issue_id: issue.id, format: :js), params: { form: { content: 'Design API' } }
        get sprint_backlog_path(product.id)
        expect(response.body).to include 'Design API'
        expect(response.body).to include %Q(test-task-status-#{issue.id}-1="todo")
      end
    end

    context 'given invalid params' do
      it do
        post work_tasks_path(issue_id: issue.id, format: :js), params: { form: { content: '' } }

        expect(response.body).to include(I18n.t('errors.messages.blank'))
      end
    end
  end

  describe 'update' do
    before do
      plan_task(issue.id, %w(Tasuku1 Tasuku2 Tasuku3))
    end

    context 'given valid params' do
      it do
        patch work_task_path(issue_id: issue.id, number: 2, format: :js), params: { form: { content: 'Yarukoto' } }

        aggregate_failures do
          expect(response.body).to include 'Yarukoto'
          expect(response.body).to_not include 'Tasuku2'
        end
      end
    end

    context 'given invalid params' do
      it do
        patch work_task_path(issue_id: issue.id, number: 2, format: :js), params: { form: { content: '' } }

        expect(response.body).to include(I18n.t('errors.messages.blank'))
      end
    end
  end

  describe 'destroy' do
    before do
      plan_task(issue.id, %w(Tasuku1 Tasuku2 Tasuku3))
    end

    it do
      delete work_task_path(issue_id: issue.id, number: 2, format: :js)

      expect(response.body).to_not include 'Tasuku2'
    end
  end
end
