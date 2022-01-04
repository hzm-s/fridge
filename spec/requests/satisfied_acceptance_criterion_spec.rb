# typed: false
require 'rails_helper'

xdescribe 'satisfied_acceptance_criterion' do
  let!(:user_account) { sign_up }
  let!(:product) { create_product(person: user_account.person_id) }
  let!(:issue) { plan_issue(product.id, acceptance_criteria: %w(AC1 AC2 AC3), size: 3, assign: true) }

  describe 'create' do
    before { sign_in(user_account) }

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
    before { sign_in(user_account) }

    before do
      satisfy_acceptance_criteria(issue.id, [1, 2, 3])
    end

    it do
      delete issue_satisfied_acceptance_criterion_path(issue_id: issue.id.to_s, number: 2)
      follow_redirect!

      aggregate_failures do
        expect(response.body).to include "satisfied-acceptance-criterion-1"
        expect(response.body).to_not include "satisfied-acceptance-criterion-2"
        expect(response.body).to include "satisfied-acceptance-criterion-3"
      end
    end
  end

  it_behaves_like('sign_in_guard') { let(:r) { post issue_satisfied_acceptance_criteria_path(issue_id: 1, number: 2) } }
  it_behaves_like('sign_in_guard') { let(:r) { delete issue_satisfied_acceptance_criterion_path(issue_id: 1, number: 2) } }
end
