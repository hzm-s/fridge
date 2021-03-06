# typed: false
require 'domain_helper'

module Plan
  RSpec.describe Plan do
    let!(:product_id) { Product::Id.create }

    describe 'Create' do
      it do
        plan = described_class.create(product_id)

        aggregate_failures do
          expect(plan.product_id).to eq product_id
          expect(plan.releases.size).to eq 1
          expect(plan.release(1).issues).to eq issue_list
        end
      end
    end

    let(:plan) { described_class.create(product_id) }
    let(:issue_a) { Issue::Id.create }
    let(:issue_b) { Issue::Id.create }
    let(:issue_c) { Issue::Id.create }
    let(:issue_d) { Issue::Id.create }
    let(:issue_e) { Issue::Id.create }
    let(:po_roles) { team_roles(:po) }
    let(:dev_roles) { team_roles(:dev) }

    describe 'Append release' do
      it do
        plan.append_release

        expect(plan.release(2).issues).to eq issue_list
      end
    end

    describe 'Update release' do
      it do
        plan.append_release
        plan.append_release

        plan.release(1).tap do |r|
          r.append_issue(issue_a)
          r.append_issue(issue_b)
          r.append_issue(issue_c)
          plan.update_release(r)
        end

        plan.release(3).tap do |r|
          r.append_issue(issue_d)
          r.append_issue(issue_e)
          plan.update_release(r)
        end

        expect(plan.release(1).issues).to eq issue_list(issue_a, issue_b, issue_c)
        expect(plan.release(2).issues).to eq issue_list
        expect(plan.release(3).issues).to eq issue_list(issue_d, issue_e)
      end
    end

    describe 'Remove release' do
      it do
        plan.append_release

        plan.remove_release(1)

        expect(plan.releases.map(&:number)).to eq [2]
      end

      it do
        plan.release(1).tap do |r|
          r.append_issue(issue_a)
          plan.update_release(r)
        end

        expect { plan.remove_release(1) }.to raise_error ReleaseIsNotEmpty
      end

      it do
        expect { plan.remove_release(1) }.to raise_error NeedAtLeastOneRelease
      end
    end
  end
end
