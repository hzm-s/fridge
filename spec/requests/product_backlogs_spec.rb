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

  let!(:issue_a) { plan_issue(product.id, release: 1) }

  context 'when PO' do
    before { sign_in(user_account_a) }

    it do
      get product_backlog_path(product_id: product.id)

      aggregate_failures do
        expect(response.body).to include 'test-update-issues-in-release-1'
        expect(response.body).to include "test-remove-issue-#{issue_a.id}"
        expect(response.body).to include "test-new-release"
        expect(response.body).to include "test-update-release-1"
        expect(response.body).to_not include "test-estimate-issue"
      end
    end
  end

  context 'when Dev' do
    before { sign_in(user_account_b) }

    it do
      get product_backlog_path(product_id: product.id)

      aggregate_failures do
        expect(response.body).to_not include 'test-update-issues-in-release-1'
        expect(response.body).to_not include "test-remove-issue-#{issue_a.id}"
        expect(response.body).to_not include "test-new-release"
        expect(response.body).to_not include "test-update-release-1"
        expect(response.body).to include "test-estimate-issue"
      end
    end
  end
end
