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

    describe 'Query recent release' do
      it do
        plan = described_class.create(product_id)
        plan.append_release
        plan.append_release
        plan.remove_release(1)

        expect(plan.recent_release.number).to eq 2
      end
    end

    let(:plan) { described_class.create(product_id) }
    let(:issue_a) { Issue::Id.create }
    let(:issue_b) { Issue::Id.create }
    let(:issue_c) { Issue::Id.create }

    describe 'Append release' do
      it do
        plan.append_release
        plan.append_release('R3')
        plan.append_release
        plan.append_release
        plan.remove_release(4)
        plan.append_release

        aggregate_failures do
          expect(plan.releases.map(&:number)).to match_array [1, 2, 3, 5, 6]
          expect(plan.release_of(3).description).to eq 'R3'
        end
      end
    end

    describe 'Update release' do
      it do
        plan.append_release

        r = plan.release_of(1)
        r.plan_issue(issue_a)
        r.plan_issue(issue_b)
        r.plan_issue(issue_c)
        r.modify_description('Updated')

        plan.update_release(r)

        aggregate_failures do
          expect(plan.release_of(1).issues).to eq issue_list(issue_a, issue_b, issue_c)
          expect(plan.release_of(1).description).to eq 'Updated'
          expect(plan.release_of(2).issues).to eq issue_list
        end
      end
    end

    describe 'Remove release' do
      before do
        plan.append_release
        plan.append_release
      end

      it do
        plan.remove_release(2)

        expect(plan.releases.map(&:number)).to match_array [1, 3]
      end

      it do
        r = plan.release_of(2)
        r.plan_issue(issue_a)
        plan.update_release(r)

        expect { plan.remove_release(2) }.to raise_error ReleaseIsNotEmpty
      end

      it do
        plan.remove_release(3)
        plan.remove_release(2)

        expect { plan.remove_release(1) }.to raise_error NeedAtLeastOneRelease
      end
    end

    describe 'Query release by issue' do
      it do
        plan.append_release

        plan.release_of(1).tap do |r|
          r.plan_issue(issue_a)
          plan.update_release(r)
        end

        plan.release_of(2).tap do |r|
          r.plan_issue(issue_b)
          r.plan_issue(issue_c)
          plan.update_release(r)
        end

        aggregate_failures do
          expect(plan.release_by_issue(issue_a).number).to eq 1
          expect(plan.release_by_issue(issue_b).number).to eq 2
          expect(plan.release_by_issue(issue_c).number).to eq 2
        end
      end
    end

    describe 'Query to remove release' do
      it do
        plan.append_release

        expect(plan).to be_can_remove_release
      end

      it do
        expect(plan).to_not be_can_remove_release
      end
    end
  end
end
