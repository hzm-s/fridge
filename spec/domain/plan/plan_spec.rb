# typed: false
require 'domain_helper'

module Plan
  RSpec.describe Plan do
    let!(:product_id) { Product::Id.create }

    describe 'Create' do
      it do
        plan = described_class.create(product_id)

        expect(plan.product_id).to eq product_id
        expect(plan.scoped).to eq ReleaseList.new
        expect(plan.not_scoped).to eq IssueList.new
      end
    end

    let(:plan) { described_class.create(product_id) }
    let(:issue_a) { Issue::Id.create }
    let(:issue_b) { Issue::Id.create }
    let(:issue_c) { Issue::Id.create }
    let(:issue_d) { Issue::Id.create }
    let(:issue_e) { Issue::Id.create }

    describe 'Update not scoped' do
      it do
        not_scoped = IssueList.new([issue_a, issue_b, issue_c])
        plan.update_not_scoped(not_scoped)
        expect(plan.not_scoped).to eq not_scoped
      end

      it do
        scoped = ReleaseList.new([
          Release.new('R', issue_list(issue_d, issue_e))
        ])
        plan.update_scoped(scoped)
        
        not_scoped = IssueList.new([issue_a, issue_b, issue_c])
        plan.update_not_scoped(not_scoped)

        aggregate_failures do
          expect(plan.scoped).to eq scoped
          expect(plan.not_scoped).to eq not_scoped
        end
      end

      it do
        scoped = ReleaseList.new([
          Release.new('R', issue_list(issue_d, issue_a, issue_e))
        ])
        plan.update_scoped(scoped)
        
        not_scoped = IssueList.new([issue_a, issue_b, issue_c])

        expect { plan.update_not_scoped(not_scoped) }.to raise_error DuplicatedIssue
      end
    end

    describe 'Update scoped' do
      it do
        scoped = ReleaseList.new([
          Release.new('R1', issue_list(issue_a, issue_b, issue_c)),
          Release.new('R2', issue_list(issue_d, issue_e))
        ])
        plan.update_scoped(scoped)
        expect(plan.scoped).to eq scoped
      end
    end
  end
end
__END__
not_scoped = plan.not_scoped.add(issue)
plan.update_not_scoped(not_scoped)

not_scoped = plan.not_scoped.remove(issue)
plan.update_not_scoped(not_scoped)

---

releases = plan.scoped.add('MVP')
plan.update_scoped(releases)

releases = plan.scoped.remove('MVP')
plan.update_scoped(releases)

---

release = plan.scoped.get('MVP')
new_release = release.add(issue)
releases = plan.scoped.update(new_release)
plan.update_scoped(releases)
