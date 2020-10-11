# typed: false
require 'domain_helper'

module Plan
  RSpec.describe Order do
    let!(:product_id) { Product::Id.create }

    describe 'Create' do
      it do
        order = described_class.create(product_id)
        expect(order.product_id).to eq product_id
        expect(order.issues).to be_empty
      end
    end

    let(:issue_a) { Issue::Id.create }
    let(:issue_b) { Issue::Id.create }
    let(:issue_c) { Issue::Id.create }

    describe 'Append issue' do
      it do
        order = described_class.create(product_id)
        order.append_issue(issue_a)
        order.append_issue(issue_b)
        order.append_issue(issue_c)
        expect(order.issues).to eq IssueList.new([issue_a, issue_b, issue_c])
      end
    end

    describe 'Remove issue' do
      it do
        order = described_class.create(product_id)
        order.append_issue(issue_a)
        order.append_issue(issue_b)
        order.append_issue(issue_c)

        order.remove_issue(issue_b)
        expect(order.issues).to eq IssueList.new([issue_a, issue_c])
      end
    end

    describe 'Swap issue positions' do
      it do
        order = described_class.create(product_id)
        order.append_issue(issue_a)
        order.append_issue(issue_b)
        order.append_issue(issue_c)

        order.swap_issues(issue_c, issue_a)
        expect(order.issues).to eq IssueList.new([issue_c, issue_a, issue_b])
      end
    end
  end
end
