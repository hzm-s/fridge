# typed: false
require 'rails_helper'

RSpec.describe PendingIssueUsecase do
  let(:product) { create_product }
  let!(:issue_a) { add_issue(product.id) }
  let!(:issue_b) { add_issue(product.id) }
  let!(:issue_c) { add_issue(product.id) }

  before do
    plan = PlanRepository::AR.find_by_product_id(product.id)
    plan.update_pending(issue_list)
    plan.update_scheduled(
      release_list({
        'R1' => issue_list(issue_a.id, issue_b.id),
        'R2' => issue_list(issue_c.id),
      })
    )
    PlanRepository::AR.store(plan)
  end

  it do
    described_class.perform(product.id, issue_b.id, 'R1')

    plan = PlanRepository::AR.find_by_product_id(product.id)
    aggregate_failures do
      expect(plan.pending).to eq issue_list(issue_b.id)
      expect(plan.scheduled).to eq release_list({
        'R1' => issue_list(issue_a.id),
        'R2' => issue_list(issue_c.id),
      })
    end

    described_class.perform(product.id, issue_c.id, 'R2')

    plan = PlanRepository::AR.find_by_product_id(product.id)
    aggregate_failures do
      expect(plan.pending).to eq issue_list(issue_c.id, issue_b.id)
      expect(plan.scheduled).to eq release_list({
        'R1' => issue_list(issue_a.id),
        'R2' => issue_list,
      })
    end
  end
end
