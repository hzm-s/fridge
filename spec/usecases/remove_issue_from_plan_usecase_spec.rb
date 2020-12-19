# typed: false
require 'rails_helper'

RSpec.describe RemoveIssueFromPlanUsecase do
  let(:product) { create_product }
  let(:issue) { add_issue(product.id) }

  context 'given not scoped issue' do
    it do
      described_class.perform(product.id, issue.id)

      plan = PlanRepository::AR.find_by_product_id(product.id)

      aggregate_failures do
        expect(plan.scoped).to eq release_list({})
        expect(plan.not_scoped).to eq issue_list
      end
    end
  end

  context 'given scoped issue' do
    it do
      plan = PlanRepository::AR.find_by_product_id(product.id)
      plan.update_not_scoped(issue_list)
      plan.update_scoped(release_list({ 'R' => issue_list(issue.id) }))
      PlanRepository::AR.store(plan)

      described_class.perform(product.id, issue.id)

      plan = PlanRepository::AR.find_by_product_id(product.id)

      aggregate_failures do
        expect(plan.scoped).to eq release_list({ 'R' => issue_list })
        expect(plan.not_scoped).to eq issue_list
      end
    end
  end
end
