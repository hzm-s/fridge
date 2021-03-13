# typed: false
require 'domain_helper'

module Plan
  RSpec.describe Plan do
    let(:product_id) { Product::Id.create }

    describe 'Create' do
      it do
        plan = described_class.create(product_id)

        aggregate_failures do
          expect(plan.product_id).to eq product_id
          expect(plan.releases.map(&:number)).to match_array [1]
        end
      end
    end

    let(:plan) { described_class.create(product_id) }
    let(:issue_a) { Issue::Id.create }
    let(:issue_b) { Issue::Id.create }
    let(:issue_c) { Issue::Id.create }

    describe 'Append release' do
      it do
        plan.append_release
        plan.append_release

        expect(plan.releases.map(&:number)).to match_array [1, 2, 3]
      end
    end

    describe 'Update release' do
      it do
        plan.append_release

        r = plan.release(1)
        r.append_issue(issue_a)
        r.append_issue(issue_b)
        r.append_issue(issue_c)

        plan.update_release(r)

        aggregate_failures do
          expect(plan.release(1).issues).to eq issue_list(issue_a, issue_b, issue_c)
          expect(plan.release(2).issues).to eq issue_list
        end
      end
    end

    describe 'Remove release' do
      it do
        plan.append_release
        plan.append_release
        plan.remove_release(2)

        expect(plan.releases.map(&:number)).to match_array [1, 3]
      end
    end
  end
end
