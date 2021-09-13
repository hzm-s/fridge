# typed: false
require 'domain_helper'

module Plan
  RSpec.describe Release do
    let(:product_id) { Product::Id.create }
    let(:issue_a) { Issue::Id.create }
    let(:issue_b) { Issue::Id.create }
    let(:issue_c) { Issue::Id.create }

    describe 'Create' do
      it do
        r = described_class.create(1)

        aggregate_failures do
          expect(r.number).to eq 1
          expect(r.title.to_s).to eq 'Release#1'
          expect(r.issues).to eq issue_list
        end
      end

      it do
        r = described_class.create(1, name('MVP'))

        aggregate_failures do
          expect(r.number).to eq 1
          expect(r.title.to_s).to eq 'MVP'
          expect(r.issues).to eq issue_list
        end
      end
    end

    describe 'Modify title' do
      it do
        release = described_class.create(1, name('Initial'))
        release.modify_title(name('Modified'))
        expect(release.title.to_s).to eq 'Modified'
      end
    end

    let(:release) { described_class.create(1) }

    describe 'Plan issue' do
      it do
        release.plan_issue(issue_c)

        expect(release.issues).to eq issue_list(issue_c)
      end

      it do
        release.plan_issue(issue_a)

        expect { release.plan_issue(issue_a) }.to raise_error DuplicatedIssue
      end
    end

    describe 'Drop issue' do
      it do
        release.plan_issue(issue_a)
        release.plan_issue(issue_b)
        release.plan_issue(issue_c)

        release.drop_issue(issue_b)

        expect(release.issues).to eq issue_list(issue_a, issue_c)
      end
    end

    describe 'Change issue priority' do
      it do
        release.plan_issue(issue_a)
        release.plan_issue(issue_b)
        release.plan_issue(issue_c)

        release.change_issue_priority(issue_c, issue_a)

        expect(release.issues).to eq issue_list(issue_c, issue_a, issue_b)
      end
    end
  end
end
