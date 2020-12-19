# typed: false
require 'rails_helper'

describe ProductBacklogQuery do
  let!(:product) { create_product }

  let!(:issue_a) { add_issue(product.id).id }
  let!(:issue_b) { add_issue(product.id).id }
  let!(:issue_c) { add_issue(product.id).id }
  let!(:issue_d) { add_issue(product.id).id }
  let!(:issue_e) { add_issue(product.id).id }
  let!(:issue_f) { add_issue(product.id).id }
  let!(:issue_g) { add_issue(product.id).id }

  it do
    plan = PlanRepository::AR.find_by_product_id(product.id)

    pending = issue_list(issue_f, issue_g)
    plan.update_pending(pending)

    scoped = release_list({
      'R1' => issue_list(issue_a, issue_b),
      'R2' => issue_list(issue_c, issue_d, issue_e)
    })
    plan.update_scoped(scoped)

    PlanRepository::AR.store(plan)

    pbl = described_class.call(product.id.to_s)

    aggregate_failures do
      expect(pbl.scoped[0].name).to eq 'R1'
      expect(pbl.scoped[0].issues.map(&:id)).to eq [issue_a, issue_b].map(&:to_s)
      expect(pbl.scoped[1].name).to eq 'R2'
      expect(pbl.scoped[1].issues.map(&:id)).to eq [issue_c, issue_d, issue_e].map(&:to_s)
      expect(pbl.pending.map(&:id)).to eq [issue_f, issue_g].map(&:to_s)
    end
  end
end
