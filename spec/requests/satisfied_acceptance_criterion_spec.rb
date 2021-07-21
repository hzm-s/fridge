# typed: false
require 'rails_helper'

RSpec.describe 'satisfied_acceptance_criterion' do
  let!(:user_account) { sign_up }
  let!(:product) { create_product(person: user_account.person_id) }
  let!(:issue) { plan_issue(product.id, acceptance_criteria: %w(AC1 AC2 AC3)) }

  before do
    sign_in(user_account)
  end

  describe 'create' do
    it do
      post issue_satisfied_acceptance_criteria_path(issue_id: issue.id.to_s, number: 2)
      follow_redirect!

      aggregate_failures do
        expect(response.body).to_not include "satisfied-acceptance-criterion-1"
        expect(response.body).to include "satisfied-acceptance-criterion-2"
        expect(response.body).to_not include "satisfied-acceptance-criterion-3"
      end
    end
  end

  describe 'destroy' do
  end
end
