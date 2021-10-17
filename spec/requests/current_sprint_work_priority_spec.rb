# typed: false
require 'rails_helper'

RSpec.describe 'current_sprint/:product_id/work_priority' do
  let!(:user_account) { sign_up }
  let!(:product) { create_product(person: user_account.person_id, roles: team_roles(:po)) }

  describe 'Update' do
    before { sign_in(user_account) }

    let!(:issue_a) { plan_issue(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1) }
    let!(:issue_b) { plan_issue(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1) }
    let!(:issue_c) { plan_issue(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1) }
    let(:sprint) { start_sprint(product.id) }

    before do
      sprint
      assign_issue_to_sprint(product.id, issue_a.id, issue_b.id, issue_c.id)
    end

    it do
      patch current_sprint_work_priority_path(product_id: product.id.to_s, format: :json),
        params: { issue_id: issue_c.id.to_s, to_index: 0 }

      sbl = SprintBacklogQuery.call(sprint.id)

      expect(sbl.items.map(&:issue_id)).to eq [issue_c.id, issue_a.id, issue_b.id].map(&:to_s)
    end
  end

  it_behaves_like('sign_in_guard') { let(:r) { patch current_sprint_work_priority_path(product_id: 1, format: :json) } }
end
