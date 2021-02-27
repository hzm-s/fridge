# typed: false
require 'rails_helper'

RSpec.describe RemoveIssueFromPlanUsecase do
  let(:product) { create_product }
  let(:issue) { add_issue(product.id) }
  let(:roles) { team_roles(:po) }

  context 'given not scheduled issue' do
    it do
      described_class.perform(product.id, roles, issue.id)

      plan = PlanRepository::AR.find_by_product_id(product.id)

      expect(plan.scheduled).to eq release_list({})
    end
  end

  context 'given scheduled issue' do
    it do
      plan = PlanRepository::AR.find_by_product_id(product.id)
      plan.update_scheduled(roles, release_list({ 'R' => issue_list(issue.id) }))
      PlanRepository::AR.store(plan)

      described_class.perform(product.id, roles, issue.id)

      plan = PlanRepository::AR.find_by_product_id(product.id)

      expect(plan.scheduled).to eq release_list({ 'R' => issue_list })
    end
  end
end
