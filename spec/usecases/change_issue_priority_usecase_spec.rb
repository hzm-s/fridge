# typed: false
require 'rails_helper'

RSpec.describe ChangeIssuePriorityUsecase do
  let(:product) { create_product }
  let!(:issue_a) { add_issue(product.id) }
  let!(:issue_b) { add_issue(product.id) }
  let!(:issue_c) { add_issue(product.id) }

  xcontext 'In not scoped' do
    it do
      described_class.perform(product.id, nil, issue_a.id, 2)

      plan = PlanRepository::AR.find_by_product_id(product.id)

      aggregate_failures do
        expect(plan.scoped).to eq Plan::ReleaseList.new
        expect(plan.not_scoped).to eq issue_list(issue_b.id, issue_c.id, issue_a.id)
      end
    end
  end

  before do
    plan = PlanRepository::AR.find_by_product_id(product.id)
    plan.update_scoped(
      release_list({ 'MVP' => issue_list(issue_a.id, issue_b.id, issue_c.id) })
    )
    plan.update_not_scoped(issue_list)
    PlanRepository::AR.store(plan)
  end

  it do
    described_class.perform(product.id, 'MVP', issue_a.id, 2)

    plan = PlanRepository::AR.find_by_product_id(product.id)

    aggregate_failures do
      expect(plan.scoped).to eq release_list({ 'MVP' => issue_list(issue_b.id, issue_c.id, issue_a.id) })
      expect(plan.not_scoped).to eq Plan::IssueList.new
    end
  end
end
