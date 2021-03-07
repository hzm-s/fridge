# typed: false
require 'domain_helper'

module Release
  RSpec.describe Release do
    let(:issue_a) { Issue::Id.create }
    let(:issue_b) { Issue::Id.create }
    let(:issue_c) { Issue::Id.create }

    describe 'Create' do
      it do
        r = described_class.create(1)

        aggregate_failures do
          expect(r.number).to eq 1
          expect(r.issues).to eq issue_list
        end
      end
    end

    let(:release) { described_class.create(1) }

    describe 'Append' do
      it do
        release.append_issue(issue_c)

        expect(release.issues).to eq issue_list(issue_c)
      end

      it do
        release.append_issue(issue_a)

        expect { release.append_issue(issue_a) }.to raise_error DuplicatedIssue
      end
    end

    describe 'Remove' do
      it do
        release.append_issue(issue_a)
        release.append_issue(issue_b)
        release.append_issue(issue_c)

        release.remove_issue(issue_b)

        expect(release.issues).to eq issue_list(issue_a, issue_c)
      end
    end

    describe 'Change issue priority' do
      it do
        release.append_issue(issue_a)
        release.append_issue(issue_b)
        release.append_issue(issue_c)

        release.sort_issue_priority(issue_c, issue_a)

        expect(release.issues).to eq issue_list(issue_c, issue_a, issue_b)
      end
    end
  end
end
