# typed: false
require 'domain_helper'

module Plan
  RSpec.describe Plan do
    let(:product_id) { Product::Id.create }
    let(:po_role) { team_roles(:po) }
    let(:dev_role) { team_roles(:dev) }
    let(:sm_role) { team_roles(:sm) }

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
        plan.append_release(po_role)
        plan.append_release(po_role)
        plan.remove_release(po_role, 1)

        expect(plan.recent_release.number).to eq 2
      end
    end

    let(:plan) { described_class.create(product_id) }
    let(:issue_a) { Issue::Id.create }
    let(:issue_b) { Issue::Id.create }
    let(:issue_c) { Issue::Id.create }

    describe 'Append release' do
      it do
        plan.append_release(po_role)
        plan.append_release(po_role, 'R3')
        plan.append_release(po_role)
        plan.append_release(po_role)
        plan.remove_release(po_role, 4)
        plan.append_release(po_role)

        aggregate_failures do
          expect(plan.releases.map(&:number)).to match_array [1, 2, 3, 5, 6]
          expect(plan.release_of(3).title).to eq 'R3'
        end
      end

      it 'Dev can NOT append release' do
        expect { plan.append_release(dev_role) }.to raise_error PermissionDenied
      end

      it 'SM can append relaese' do
        expect { plan.append_release(sm_role) }.to_not raise_error
      end
    end

    describe 'Update release' do
      it do
        plan.append_release(po_role)

        r = plan.release_of(1)
        r.plan_issue(issue_a)
        r.plan_issue(issue_b)
        r.plan_issue(issue_c)
        r.modify_title('Updated')

        plan.update_release(po_role, r)

        aggregate_failures do
          expect(plan.release_of(1).issues).to eq issue_list(issue_a, issue_b, issue_c)
          expect(plan.release_of(1).title).to eq 'Updated'
          expect(plan.release_of(2).issues).to eq issue_list
        end
      end

      it 'Dev can NOT update release' do
        expect { plan.update_release(dev_role, plan.recent_release) }
          .to raise_error PermissionDenied
      end

      it 'SM can update relaese' do
        expect { plan.update_release(sm_role, plan.recent_release) }
          .to_not raise_error
      end
    end

    describe 'Remove release' do
      before do
        plan.append_release(po_role)
        plan.append_release(po_role)
      end

      it do
        plan.remove_release(po_role, 2)

        expect(plan.releases.map(&:number)).to match_array [1, 3]
      end

      it do
        r = plan.release_of(2)
        r.plan_issue(issue_a)
        plan.update_release(po_role, r)

        expect { plan.remove_release(po_role, 2) }.to raise_error ReleaseIsNotEmpty
      end

      it do
        plan.remove_release(po_role, 3)
        plan.remove_release(po_role, 2)

        expect { plan.remove_release(po_role, 1) }.to raise_error NeedAtLeastOneRelease
      end

      it 'Dev can NOT update release' do
        expect { plan.remove_release(dev_role, 2) }.to raise_error PermissionDenied
      end

      it 'SM can update relaese' do
        expect { plan.remove_release(sm_role, 2) }.to_not raise_error
      end
    end

    describe 'Query release by issue' do
      it do
        plan.append_release(po_role)

        plan.release_of(1).tap do |r|
          r.plan_issue(issue_a)
          plan.update_release(po_role, r)
        end

        plan.release_of(2).tap do |r|
          r.plan_issue(issue_b)
          r.plan_issue(issue_c)
          plan.update_release(po_role, r)
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
        plan.append_release(po_role)

        expect(plan).to be_can_remove_release
      end

      it do
        expect(plan).to_not be_can_remove_release
      end
    end
  end
end
