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

    xdescribe 'Append issue' do
      it do
        plan = described_class.create(product_id)
        plan.append_issue(issue_a)
        plan.append_issue(issue_b)
        plan.append_issue(issue_c)
        expect(plan.order).to eq Order.new([issue_a, issue_b, issue_c])
      end
    end

    xdescribe 'Remove issue' do
      it do
        plan = described_class.create(product_id)
        plan.append_issue(issue_a)
        plan.append_issue(issue_b)
        plan.append_issue(issue_c)

        plan.remove_issue(issue_b)
        expect(plan.order).to eq Order.new([issue_a, issue_c])
      end

      it do
        plan = described_class.create(product_id)
        plan.append_issue(issue_a)
        plan.append_issue(issue_b)
        plan.append_issue(issue_c)
        plan.specify_release('MVP', issue_c)

        plan.remove_issue(issue_c)

        expect(plan.scoped).to eq [Release.new('MVP', [issue_a, issue_b])]
        expect(plan.unscoped).to eq []
      end
    end

    xdescribe 'Swap issue positions' do
      it do
        plan = described_class.create(product_id)
        plan.append_issue(issue_a)
        plan.append_issue(issue_b)
        plan.append_issue(issue_c)

        plan.swap_issues(issue_c, issue_a)
        expect(plan.order).to eq Order.new([issue_c, issue_a, issue_b])
      end
    end

    xdescribe 'Specify release' do
      it do
        plan = described_class.create(product_id)
        plan.append_issue(issue_a)
        plan.append_issue(issue_b)
        plan.append_issue(issue_c)

        plan.specify_release('MVP', issue_b)
        expect(plan.scoped).to eq [Release.new('MVP', [issue_a, issue_b])]
        expect(plan.unscoped).to eq [issue_c]
      end
    end
  end
end
