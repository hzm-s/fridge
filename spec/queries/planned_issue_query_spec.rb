# typed: false
require 'rails_helper'

RSpec.describe PlannedIssueQuery do
  let(:product) { create_product }
  let!(:issue_a) { plan_issue(product.id, release: 1).id }
  let!(:issue_b) { plan_issue(product.id, release: 1).id }
  let!(:issue_c) { plan_issue(product.id, release: 2).id }
  let!(:issue_d) { plan_issue(product.id, release: 3).id }
  let!(:issue_e) { plan_issue(product.id, release: 3).id }

  it do
    plan = plan_of(product.id)

    query = described_class.new(plan)

    aggregate_failures do
      expect(query.call(1, 0)).to eq issue_a
      expect(query.call(1, 1)).to eq issue_b
      expect(query.call(1, 2)).to be_nil
      expect(query.call(2, 0)).to eq issue_c
      expect(query.call(2, 2)).to be_nil
      expect(query.call(3, 0)).to eq issue_d
      expect(query.call(3, 1)).to eq issue_e
      expect(query.call(3, 2)).to be_nil
      expect(query.call(4, 0)).to be_nil
    end
  end
end
