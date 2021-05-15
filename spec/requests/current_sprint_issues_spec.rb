# typed: false
require 'rails_helper'

RSpec.describe 'current_sprint/:product_id/issues' do
  let!(:user_account) { sign_up }
  let!(:product) { create_product(person: user_account.person_id, roles: team_roles(:po)) }

  before do
    sign_in(user_account)
  end

  describe 'Create' do
    let!(:issue) { plan_issue(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1) }

    context 'sprint started' do
      before { start_sprint(product.id) }

      it do
        post current_sprint_issues_path(product_id: product.id, format: :js), params: { issue_id: issue.id.to_s }
        expect(response.body).to include "test-issue-#{issue.id}-wip"
      end
    end

    context 'sprint NOT started' do
      it do
        post current_sprint_issues_path(product_id: product.id, format: :js), params: { issue_id: issue.id.to_s }
        follow_redirect!
        follow_redirect!
        expect(response.body).to include I18n.t('feedbacks.sprint.not_started')
      end
    end
  end
end
