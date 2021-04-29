# typed: false
require 'rails_helper'

RSpec.describe 'product_backlogs' do
  let!(:user_account_a) { sign_up }
  let!(:user_account_b) { sign_up }
  let!(:product) do
    create_product(
      person: user_account_a.person_id,
      roles: team_roles(:po),
      members: [team_member(user_account_b.person_id, :dev)]
    )
  end

  let!(:issue_preparation) { plan_issue(product.id, release: 1) }
  let!(:issue_ready) { plan_issue(product.id, release: 1, acceptance_criteria: %w(AC1), size: 3 ) }

  context 'when PO' do
    before { sign_in(user_account_a) }

    it do
      get product_backlog_path(product_id: product.id)

      aggregate_failures do
        expect(response.body).to include 'test-update-issues-in-release-1'
        expect(response.body).to include "test-remove-issue-#{issue_preparation.id}"
        expect(response.body).to include "test-new-release"
        expect(response.body).to include "test-update-release-1"
        expect(response.body).to include "test-assign-issue-to-sprint-#{issue_ready.id}"
        expect(response.body).to_not include "test-estimate-issue-#{issue_preparation.id}"
        expect(response.body).to_not include "test-estimate-issue-#{issue_ready.id}"
      end
    end
  end

  context 'when Dev' do
    before { sign_in(user_account_b) }

    it do
      get product_backlog_path(product_id: product.id)

      aggregate_failures do
        expect(response.body).to_not include 'test-update-issues-in-release-1'
        expect(response.body).to_not include "test-remove-issue-#{issue_preparation.id}"
        expect(response.body).to_not include "test-new-release"
        expect(response.body).to_not include "test-update-release-1"
        expect(response.body).to_not include "test-assign-issue-to-sprint-#{issue_ready.id}"
        expect(response.body).to include "test-estimate-issue-#{issue_preparation.id}"
        expect(response.body).to include "test-estimate-issue-#{issue_ready.id}"
      end
    end
  end
end
