# typed: false
require 'rails_helper'

RSpec.describe do
  let!(:user_account) { sign_up }
  let!(:product) { create_product(person: user_account.person_id, roles: team_roles(:dev)) }

  before do
    sign_in(user_account)
  end

  describe 'create' do
    let!(:issue) { plan_issue(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1) }

    before do
      start_sprint(product.id)
      assign_issue_to_sprint(product.id, issue.id)
    end

    it do
      post work_tasks_path(issue_id: issue.id, format: :js), params: { form: { content: 'Design API' } }
      get sprint_backlog_path(product.id)
      expect(response.body).to include 'Design API'
    end
  end
end
