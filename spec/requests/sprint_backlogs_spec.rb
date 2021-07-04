# typed: false
require 'rails_helper'

RSpec.describe 'sprint_backlogs' do
  let!(:user_account_po) { sign_up }
  let!(:user_account_dev) { sign_up }
  let!(:product) do
    create_product(
      person: user_account_po.person_id,
      roles: team_roles(:po),
      members: [team_member(user_account_dev.person_id, :dev)]
    )
  end

  context 'Sprint status' do
    before { sign_in(user_account_po) }

    context 'current sprint is NOT exists' do
      it do
        get sprint_backlog_path(product.id)
        follow_redirect!
        expect(response.body).to include 'test-start-sprint'
      end
    end

    context 'current sprint is exists' do
      let!(:sprint) { start_sprint(product.id) }

      it do
        get sprint_backlog_path(product.id)
        expect(response.body).to include "test-sprint-backlog-#{sprint.id}"
      end
    end
  end

  describe 'Permission of actions' do
    let!(:issue) { plan_issue(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1) }

    before do
      start_sprint(product.id)
      assign_issue_to_sprint(product.id, issue.id)
    end

    context 'when PO' do
      before { sign_in(user_account_po) }

      it do
        get sprint_backlog_path(product.id)

        aggregate_failures do
          expect(response.body).to include "test-revert-issue"
          expect(response.body).to include "test-change-work-priority"
        end
      end
    end

    context 'when Dev' do
      before { sign_in(user_account_dev) }

      it do
        get sprint_backlog_path(product.id)

        aggregate_failures do
          expect(response.body).to_not include "test-revert-issue"
          expect(response.body).to_not include "test-change-work-priority"
        end
      end
    end
  end
end
