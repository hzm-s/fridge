# typed: false
require 'rails_helper'

RSpec.describe AddIssueToReleaseUsecase do
  let(:product) { create_product }
  let!(:issue_a) { add_issue(product.id) }
  let!(:issue_b) { add_issue(product.id) }
  let!(:issue_c) { add_issue(product.id) }
  let!(:issue_d) { add_issue(product.id) }
  let!(:issue_e) { add_issue(product.id) }

  before do
    plan = PlanRepository::AR.find_by_product_id(product.id)
    plan.update_not_scoped(issue_list(issue_c.id, issue_e.id))
    plan.update_scoped(release_list({
      'R1' => issue_list(issue_d.id),
      'R2' => issue_list(issue_a.id, issue_b.id),
    }))
    PlanRepository::AR.store(plan)
  end

  it do
    described_class.perform(product.id, issue_c.id, 'R2', 1)

    plan = PlanRepository::AR.find_by_product_id(product.id)

    aggregate_failures do
      expect(plan.scoped).to eq release_list({
        'R1' => issue_list(issue_d.id),
        'R2' => issue_list(issue_a.id, issue_c.id, issue_b.id),
      })
      expect(plan.not_scoped).to eq issue_list(issue_e.id)
    end
  end
end
