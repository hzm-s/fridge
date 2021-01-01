# typed: false
require 'domain_helper'

module Plan
  RSpec.describe ReleaseList do
    let(:issue_a) { Issue::Id.create }
    let(:issue_b) { Issue::Id.create }
    let(:issue_c) { Issue::Id.create }
    let(:issue_d) { Issue::Id.create }
    let(:issue_e) { Issue::Id.create }
    let(:issue_f) { Issue::Id.create }
    let(:issue_g) { Issue::Id.create }

    describe 'Append' do
      it do
        list = described_class.new
        list = list.append(Release.new('MVP'))
        expect(list).to eq described_class.new([
          Release.new('MVP')
        ])
      end

      it do
        list = described_class.new([
          Release.new('R1', issue_list(issue_a, issue_b)),
          Release.new('R2', issue_list(issue_c, issue_d))
        ])

        r = Release.new('R3', issue_list(issue_e, issue_f))
        expect { list.append(r) }.to_not raise_error
      end

      it do
        list = described_class.new([
          Release.new('R1', issue_list(issue_a, issue_b)),
          Release.new('R2', issue_list(issue_c, issue_d))
        ])

        r = Release.new('R3', issue_list(issue_e, issue_d, issue_f))
        expect { list.append(r) }.to raise_error DuplicatedIssue
      end
    end

    describe 'Remove' do
      it do
        list = described_class.new([Release.new('R1'), Release.new('R2'), Release.new('R3')])
        list = list.remove('R2')
        expect(list).to eq described_class.new([
          Release.new('R1'),
          Release.new('R3')
        ])
      end

      it do
        list = described_class.new([Release.new('R1', issue_list(Issue::Id.create))])
        expect { list.remove('R1') }.to raise_error ReleaseIsNotEmpty
      end
    end

    describe 'Append issue' do
      it do
        list = described_class.new([
          Release.new('R1', issue_list(issue_a, issue_b, issue_c)),
          Release.new('R2', issue_list(issue_d, issue_e, issue_f)),
        ])
        appended = list.append_issue('R2', issue_g)
        expect(appended).to eq described_class.new([
          Release.new('R1', issue_list(issue_a, issue_b, issue_c)),
          Release.new('R2', issue_list(issue_d, issue_e, issue_f, issue_g)),
        ])
      end
    end

    describe 'Change issue priority' do
      it do
        list = described_class.new([
          Release.new('R1', issue_list(issue_a, issue_b, issue_c)),
          Release.new('R2', issue_list(issue_d, issue_e, issue_f)),
        ])
        swapped = list.change_issue_priority('R1', issue_b, issue_a)
        expect(swapped).to eq described_class.new([
          Release.new('R1', issue_list(issue_b, issue_a, issue_c)),
          Release.new('R2', issue_list(issue_d, issue_e, issue_f)),
        ])
      end
    end

    describe 'Reschedule issue' do
      it do
        list = described_class.new([
          Release.new('R1', issue_list(issue_a, issue_b, issue_c)),
          Release.new('R2', issue_list(issue_d, issue_e, issue_f)),
        ])
        rescheduled = list.reschedule_issue(issue_a, 'R1', 'R2')
        expect(rescheduled).to eq described_class.new([
          Release.new('R1', issue_list(issue_b, issue_c)),
          Release.new('R2', issue_list(issue_d, issue_e, issue_f, issue_a)),
        ])
      end
    end

    describe 'Change release name' do
      it do
        list = described_class.new([
          Release.new('R1', issue_list(issue_a, issue_b, issue_c)),
          Release.new('R2', issue_list(issue_d, issue_e, issue_f)),
        ])
        name_changed = list.change_release_name('MVP', 'R2')
        expect(name_changed).to eq described_class.new([
          Release.new('R1', issue_list(issue_a, issue_b, issue_c)),
          Release.new('MVP', issue_list(issue_d, issue_e, issue_f)),
        ])
      end
    end

    describe 'Update' do
      it do
        list = described_class.new([
          Release.new('R1', issue_list(issue_a, issue_b, issue_c)),
          Release.new('R2', issue_list(issue_d, issue_e)),
          Release.new('R3', issue_list(issue_f, issue_g)),
        ])

        list = list.update(Release.new('R1', issue_list(issue_b, issue_c, issue_a)))

        expect(list).to eq described_class.new([
          Release.new('R1', issue_list(issue_b, issue_c, issue_a)),
          Release.new('R2', issue_list(issue_d, issue_e)),
          Release.new('R3', issue_list(issue_f, issue_g)),
        ])
      end

      it do
        list = described_class.new([
          Release.new('R1', issue_list(issue_a, issue_b, issue_c)),
          Release.new('R2', issue_list(issue_d, issue_e)),
          Release.new('R3', issue_list(issue_f, issue_g)),
        ])

        expect { list.update(Release.new('R2', issue_list(issue_e, issue_d, issue_g))) }
          .to raise_error(DuplicatedIssue)
      end
    end

    describe 'Check to have same issue' do
      it do
        releases = described_class.new
        issues = issue_list
        expect(releases.have_same_issue?(issues)).to be false
      end

      it do
        releases = described_class.new([Release.new('MVP', issue_list(issue_a, issue_b, issue_c))])
        issues = issue_list
        expect(releases.have_same_issue?(issues)).to be false
      end

      it do
        releases = described_class.new
        issues = issue_list(issue_a, issue_b, issue_c)
        expect(releases.have_same_issue?(issues)).to be false
      end

      it do
        releases = described_class.new([
          Release.new('R1', issue_list(issue_a, issue_b)),
          Release.new('R2', issue_list(issue_c, issue_d, issue_e)),
        ])
        issues = issue_list(issue_f, issue_g)
        expect(releases.have_same_issue?(issues)).to be false
      end

      it do
        releases = described_class.new([
          Release.new('R1', issue_list(issue_a, issue_b)),
          Release.new('R2', issue_list(issue_c, issue_d, issue_e)),
        ])
        issues = issue_list(issue_f, issue_a, issue_g)
        expect(releases.have_same_issue?(issues)).to be true
      end
    end
  end
end
