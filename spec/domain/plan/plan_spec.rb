# typed: false
require 'domain_helper'

module Plan
  RSpec.describe Plan do
    let!(:product_id) { Product::Id.create }

    describe 'Create' do
      it do
        plan = described_class.create(product_id)
        expect(plan.product_id).to eq product_id
        expect(plan.order).to be_empty
      end
    end

    let(:issue_a) { Issue::Id.create }
    let(:issue_b) { Issue::Id.create }
    let(:issue_c) { Issue::Id.create }

    describe 'Append issue' do
      it do
        plan = described_class.create(product_id)
        plan.append_issue(issue_a)
        plan.append_issue(issue_b)
        plan.append_issue(issue_c)
        expect(plan.order).to eq Order.new([issue_a, issue_b, issue_c])
      end
    end

    describe 'Remove issue' do
      it do
        plan = described_class.create(product_id)
        plan.append_issue(issue_a)
        plan.append_issue(issue_b)
        plan.append_issue(issue_c)

        plan.remove_issue(issue_b)
        expect(plan.order).to eq Order.new([issue_a, issue_c])
      end
    end

    describe 'Swap issue positions' do
      it do
        plan = described_class.create(product_id)
        plan.append_issue(issue_a)
        plan.append_issue(issue_b)
        plan.append_issue(issue_c)

        plan.swap_issues(issue_c, issue_a)
        expect(plan.order).to eq Order.new([issue_c, issue_a, issue_b])
      end
    end

    xdescribe 'Consolidate issues into release' do
      it do
        plan = described_class.create(product_id)
        plan.append_issue(issue_a)
        plan.append_issue(issue_b)
        plan.append_issue(issue_c)

        plan.consolidate_issues_into('MVP', [issue_a, issue_b])
        expect(plan.order).to eq Order.new([
          OrderedIssue.new(issue_a, 'MVP'),
          OrderedIssue.new(issue_b, 'MVP'),
        ])
      end
    end
  end
end
