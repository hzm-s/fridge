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

    let(:plan) { described_class.create(product_id) }
    let(:issue_a) { Issue::Id.create }
    let(:issue_b) { Issue::Id.create }
    let(:issue_c) { Issue::Id.create }
    let(:issue_d) { Issue::Id.create }
    let(:issue_e) { Issue::Id.create }

    describe 'Add release' do
      it do
        issues = issue_list(issue_a, issue_b, issue_c)
        plan.update_not_scoped(issues)

        release = Release.new('MVP', issue_list)
        plan.add_release(release)

        aggregate_failures do
          expect(plan.scoped).to eq [release]
          expect(plan.not_scoped).to eq issues
        end
      end
    end

    describe 'Update release' do
      it do
        before = Release.new('MVP', issue_list)
        plan.add_release(before)

        after = Release.new('MVP', issue_list(issue_a, issue_b))
        plan.update_scoped(after)

        aggregate_failures do
          expect(plan.scoped).to eq [after]
          expect(plan.not_scoped).to eq issue_list
        end
      end

      it do
        plan.update_not_scoped(issue_list(issue_a, issue_b))

        before = Release.new('MVP', issue_list)
        plan.add_release(before)

        after = Release.new('MVP', issue_list(issue_c, issue_a))
        plan.update_scoped(after)

        aggregate_failures do
          expect(plan.scoped).to eq [before]
          expect(plan.not_scoped).to eq issue_list(issue_a, issue_b)
        end
      end
    end

    describe 'Remove release' do
      it do
        release = Release.new('MVP', issue_list)
        plan.add_release(release)

        plan.remove_release('MVP')

        aggregate_failures do
          expect(plan.scoped).to eq []
          expect(plan.not_scoped).to eq issue_list
        end
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
