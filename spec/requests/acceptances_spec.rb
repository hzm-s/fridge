# typed: false
require 'rails_helper'

RSpec.describe 'acceptances' do
  let!(:user_account) { sign_up }
  let!(:product) { create_product(person: user_account.person_id) }
  let!(:issue) { plan_issue(product.id, 'AITEMU_NO_SETSUMEI', acceptance_criteria: %w(AC1 AC2 AC3), size: 3, assign: true) }

  before do
    sign_in(user_account)
  end

  describe 'show' do
    it do
      get issue_acceptance_path(issue_id: issue.id.to_s)

      aggregate_failures do
        expect(response.body).to include 'AITEMU_NO_SETSUMEI'
        expect(response.body).to include 'AC1'
        expect(response.body).to include 'AC2'
        expect(response.body).to include 'AC3'
      end
    end
  end

  describe 'update' do
    before do
      satisfy_acceptance_criteria(issue.id, [1, 2, 3])
    end

    it do
      patch issue_acceptance_path(issue_id: issue.id.to_s)
      get sprint_backlog_path(product.id)
      expect(response.body).to include I18n.t('domain.issue.statuses.accepted')
    end
  end
end
