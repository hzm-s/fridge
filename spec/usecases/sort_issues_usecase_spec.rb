# typed: false
require 'rails_helper'

RSpec.describe SortIssuesUsecase do
  let(:product) { create_product }
  let!(:issue_a) { add_issue(product.id) }
  let!(:issue_b) { add_issue(product.id) }
  let!(:issue_c) { add_issue(product.id) }

  it do
    described_class.perform(product.id, issue_a.id, 2)

    plan = PlanRepository::AR.find_by_product_id(product.id)

    aggregate_failures do
      expect(plan.scoped).to eq Plan::ReleaseList.new
      expect(plan.not_scoped).to eq issue_list(issue_b.id, issue_c.id, issue_a.id)
    end
  end
end
