# typed: false
require 'rails_helper'

RSpec.describe ChangeIssuePriorityUsecase do
  let(:product) { create_product }
  let!(:issue_a) { add_issue(product.id) }
  let!(:issue_b) { add_issue(product.id) }
  let!(:issue_c) { add_issue(product.id) }
  let(:roles) { team_roles(:po) }

  before do
    plan = PlanRepository::AR.find_by_product_id(product.id)
    plan.update_pending(issue_list)
    plan.update_scheduled(
      roles,
      release_list({ 'MVP' => issue_list(issue_a.id, issue_b.id, issue_c.id) })
    )
    PlanRepository::AR.store(plan)
  end

  it do
    described_class.perform(product.id, roles, 'MVP', issue_a.id, 2)

    plan = PlanRepository::AR.find_by_product_id(product.id)

    aggregate_failures do
      expect(plan.scheduled).to eq release_list({ 'MVP' => issue_list(issue_b.id, issue_c.id, issue_a.id) })
      expect(plan.pending).to eq Plan::IssueList.new
    end
  end
end
