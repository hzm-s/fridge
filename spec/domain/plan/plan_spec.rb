# typed: false
require 'domain_helper'

module Plan
  RSpec.describe Plan do
    let!(:product_id) { Product::Id.create }

    describe 'Create' do
      it do
        plan = described_class.create(product_id)

        expect(plan.product_id).to eq product_id
        expect(plan.releases).to eq [Release.new(1, issue_list)]
      end
    end

    let(:plan) { described_class.create(product_id) }
    let(:issue_a) { Issue::Id.create }
    let(:issue_b) { Issue::Id.create }
    let(:issue_c) { Issue::Id.create }
    let(:issue_d) { Issue::Id.create }
    let(:issue_e) { Issue::Id.create }
    let(:issue_f) { Issue::Id.create }
    let(:issue_g) { Issue::Id.create }
    let(:po_roles) { team_roles(:po) }
    let(:dev_roles) { team_roles(:dev) }

    describe 'Remove issue' do
      before do
        plan.update_scheduled(po_roles, release_list({
          'R1' => issue_list(issue_c, issue_d),
          'R2' => issue_list(issue_e, issue_f, issue_g),
        }))
      end

      it do
        plan.remove_issue(po_roles, issue_f)

        expect(plan.scheduled).to eq release_list({
          'R1' => issue_list(issue_c, issue_d),
          'R2' => issue_list(issue_e, issue_g),
        })
      end
    end

    describe 'Update' do
      it do
        scheduled = ReleaseList.new([
          Release.new('R1', issue_list(issue_a, issue_b, issue_c)),
          Release.new('R2', issue_list(issue_d, issue_e))
        ])
        plan.update_scheduled(po_roles, scheduled)
        expect(plan.scheduled).to eq scheduled
      end
    end

    describe 'Check permission' do
      let(:scheduled) { release_list('Release' => issue_list(issue_a)) }

      it do
        expect { plan.update_scheduled(po_roles, scheduled) }
          .to_not raise_error
      end

      it do
        expect { plan.update_scheduled(dev_roles, scheduled) }
          .to raise_error PermissionDenied
      end
    end
  end
end
