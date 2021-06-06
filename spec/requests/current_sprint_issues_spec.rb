# typed: false
require 'rails_helper'

RSpec.describe 'current_sprint/:product_id/issues' do
  let!(:user_account) { sign_up }
  let!(:product) { create_product(person: user_account.person_id, roles: team_roles(:po)) }

  before do
    sign_in(user_account)
  end

  describe 'Create' do
    let!(:issue) { plan_issue(product.id, 'KINOU', acceptance_criteria: %w(UKEIRE), size: 3, release: 1) }

    context 'sprint started' do
      before { start_sprint(product.id) }

      it do
        post current_sprint_issues_path(product_id: product.id, format: :js), params: { issue_id: issue.id.to_s }

        aggregate_failures do
          expect(response.body).to include I18n.t('feedbacks.issue.assign_to_sprint')
          expect(response.body).to include "test-issue-#{issue.id}-wip"

          get sprint_backlog_path(product.id)
          expect(response.body).to include "test-sbi-#{issue.id}"
          expect(response.body).to include 'KINOU'
          expect(response.body).to include 'UKEIRE'
        end
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

  describe 'Destroy' do
    let!(:issue) { plan_issue(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1) }

    before do
      start_sprint(product.id)
      assign_issue_to_sprint(product.id, issue.id)
    end

    it do
      delete current_sprint_issue_path(product_id: product.id.to_s, id: issue.id.to_s)

      aggregate_failures do
        follow_redirect!
        expect(response.body).to include I18n.t('feedbacks.issue.revert_from_sprint')
        expect(response.body).to_not include "test-sbi-#{issue.id}"

        get product_backlog_path(product.id)
        expect(response.body).to include "test-issue-#{issue.id}-ready"
      end
    end
  end
end
