# typed: false
require 'domain_helper'

module Plan
  RSpec.describe Plan do
    let!(:product_id) { Product::Id.create }

    describe 'Create' do
      it do
        plan = described_class.create(product_id)
        expect(plan.product_id).to eq product_id
        expect(plan.scoped).to be_empty
        expect(plan.not_scoped).to eq IssueList.new([])
      end
    end

    let(:issue_a) { Issue::Id.create }
    let(:issue_b) { Issue::Id.create }
    let(:issue_c) { Issue::Id.create }
    let(:issue_d) { Issue::Id.create }
    let(:issue_e) { Issue::Id.create }

    describe 'Add issue' do
      it do
        plan = described_class.create(product_id)

        plan.add_issue(issue_a)

        aggregate_failures do
          expect(plan.scoped).to be_empty
          expect(plan.not_scoped).to eq IssueList.new([issue_a])
        end
      end
    end
  end
end
