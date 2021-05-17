# typed: false
require 'rails_helper'

RSpec.describe 'sprint_backlogs' do
  let!(:user_account) { sign_up }
  let!(:product) { create_product(person: user_account.person_id) }

  before do
    sign_in(user_account)
  end

  describe 'show' do
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

    context 'issues assigned' do
      let!(:issue) { plan_issue(product.id, 'ABC', acceptance_criteria: %w(XYZ), size: 3, release: 1) }

      before do
        start_sprint(product.id)
        assign_issue_to_sprint(product.id, issue.id)
      end

      it do
        get sprint_backlog_path(product.id)

        aggregate_failures do
          expect(response.body).to include 'ABC'
          expect(response.body).to include 'XYZ'
        end
      end
    end
  end
end
