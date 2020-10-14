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

    describe 'Specify order' do
      it do
        plan = described_class.create(product_id)
        order = Order.new([issue_a, issue_b, issue_c])

        plan.specify_order(order)

        expect(plan.order).to eq order
      end
    end

    xdescribe 'Consolidate issues into release' do
      it do
        plan = described_class.create(product_id)
        order = Order.new([issue_a, issue_b, issue_c])
        plan.specify_order(order)

        plan.consolidate_issues_into('MVP', [issue_a, issue_b])

        expect(plan.releases).to eq [
          Release.new('MVP', [issue_a, issue_b])
        ]
      end
    end
  end
end
