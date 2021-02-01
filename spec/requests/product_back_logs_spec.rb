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

  let!(:issue_a) { add_issue(product.id) }
  let!(:issue_b) { add_issue(product.id) }
  let!(:issue_c) { add_issue(product.id) }

  before do
    plan = PlanRepository::AR.find_by_product_id(product.id)
    plan.update_pending(issue_list(issue_a.id))
    plan.update_scheduled(
      team_roles(:po),
      release_list({
        'MVP' => issue_list(issue_b.id, issue_c.id),
      })
    )
    PlanRepository::AR.store(plan)
  end

  context 'when PO' do
    before { sign_in(user_account_a) }

    it do
      get product_backlog_path(product_id: product.id)

      aggregate_failures do
        expect(response.body).to include 'test-update-release-MVP'
        expect(response.body).to include 'test-update-pending'
        expect(response.body).to include "test-remove-issue-#{issue_b.id}"
        expect(response.body).to include "test-remove-issue-#{issue_a.id}"
        expect(response.body).to include "test-new-release"
      end
    end
  end

  context 'when Dev' do
    before { sign_in(user_account_b) }

    it do
      get product_backlog_path(product_id: product.id)

      aggregate_failures do
        expect(response.body).to_not include 'test-update-release-MVP'
        expect(response.body).to include 'test-update-pending'
        expect(response.body).to_not include "test-remove-issue-#{issue_b.id}"
        expect(response.body).to include "test-remove-issue-#{issue_a.id}"
        expect(response.body).to_not include "test-new-release"
      end
    end
  end
end
