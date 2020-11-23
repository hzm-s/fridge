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
