# typed: false
require 'domain_helper'

module Plan
  RSpec.describe Plan do
    let!(:product_id) { Product::Id.create }

    describe 'Create' do
      it do
        plan = described_class.create(product_id)

        expect(plan.product_id).to eq product_id
        expect(plan.scheduled).to eq ReleaseList.new
        expect(plan.pending).to eq IssueList.new
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
        plan.update_pending(issue_list(issue_a, issue_b))
        plan.update_scheduled(po_roles, release_list({
          'R1' => issue_list(issue_c, issue_d),
          'R2' => issue_list(issue_e, issue_f, issue_g),
        }))
      end

      context 'remove not scheduled issue' do
        it do
          plan.remove_issue(po_roles, issue_a)

          aggregate_failures do
            expect(plan.pending).to eq issue_list(issue_b)
            expect(plan.scheduled).to eq release_list({
              'R1' => issue_list(issue_c, issue_d),
              'R2' => issue_list(issue_e, issue_f, issue_g),
            })
          end
        end
      end

      context 'remove scheduled issue' do
        it do
          plan.remove_issue(po_roles, issue_f)

          aggregate_failures do
            expect(plan.pending).to eq issue_list(issue_a, issue_b)
            expect(plan.scheduled).to eq release_list({
              'R1' => issue_list(issue_c, issue_d),
              'R2' => issue_list(issue_e, issue_g),
            })
          end
        end
      end
    end

    describe 'Update not scheduled' do
      it do
        pending = IssueList.new([issue_a, issue_b, issue_c])
        plan.update_pending(pending)
        expect(plan.pending).to eq pending
      end

      it do
        scheduled = ReleaseList.new([
          Release.new('R', issue_list(issue_d, issue_e))
        ])
        plan.update_scheduled(po_roles, scheduled)

        pending = IssueList.new([issue_a, issue_b, issue_c])
        plan.update_pending(pending)

        aggregate_failures do
          expect(plan.scheduled).to eq scheduled
          expect(plan.pending).to eq pending
        end
      end

      it do
        scheduled = ReleaseList.new([
          Release.new('R', issue_list(issue_d, issue_a, issue_e))
        ])
        plan.update_scheduled(po_roles, scheduled)

        pending = IssueList.new([issue_a, issue_b, issue_c])

        expect { plan.update_pending(pending) }.to raise_error DuplicatedIssue
      end
    end

    describe 'Update scheduled' do
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

      it do
        scheduled = ReleaseList.new([
          Release.new('R1', issue_list(issue_a, issue_b, issue_c)),
          Release.new('R2', issue_list(issue_d, issue_e))
        ])
        plan.update_scheduled(po_roles, scheduled)
        expect(plan.scheduled).to eq scheduled
      end

      it do
        pending = IssueList.new([issue_a, issue_b, issue_c])
        plan.update_pending(pending)

        scheduled = ReleaseList.new([
          Release.new('R', issue_list(issue_d, issue_e))
        ])
        plan.update_scheduled(po_roles, scheduled)

        aggregate_failures do
          expect(plan.scheduled).to eq scheduled
          expect(plan.pending).to eq pending
        end
      end

      it do
        pending = IssueList.new([issue_a, issue_b])
        plan.update_pending(pending)

        scheduled = ReleaseList.new([
          Release.new('R1', issue_list(issue_c, issue_d, issue_e)),
          Release.new('R2', issue_list(issue_f, issue_a, issue_g))
        ])

        expect { plan.update_scheduled(po_roles, scheduled) }.to raise_error DuplicatedIssue
      end

      it do
        pending = IssueList.new([issue_a, issue_b, issue_c, issue_d, issue_e, issue_f, issue_g])
        plan.update_pending(pending)

        scheduled = ReleaseList.new([
          Release.new('R1', issue_list(issue_a, issue_b)),
          Release.new('R2', issue_list(issue_c, issue_d, issue_e))
        ])

        expect { plan.update_scheduled(po_roles, scheduled) }.to raise_error DuplicatedIssue
      end
    end
  end
end
