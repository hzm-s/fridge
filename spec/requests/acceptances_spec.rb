# typed: false
require 'rails_helper'

RSpec.describe 'acceptances' do
  let!(:user_account) { sign_up }
  let!(:product) { create_product(person: user_account.person_id) }
  let!(:issue) { plan_issue(product.id, 'AITEMU_NO_SETSUMEI', acceptance_criteria: %w(AC1 AC2 AC3)) }

  before do
    sign_in(user_account)
  end

  describe 'new' do
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
end
