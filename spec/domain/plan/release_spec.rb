# typed: false
require 'domain_helper'

module Plan
  RSpec.describe Release do
    let(:issue_a) { Issue::Id.create }
    let(:issue_b) { Issue::Id.create }
    let(:issue_c) { Issue::Id.create }

    describe 'Append' do
      it do
        r = described_class.new('MVP', issue_list(issue_a, issue_b))
        r = r.append_issue(issue_c)
        expect(r).to eq described_class.new('MVP', issue_list(issue_a, issue_b, issue_c))
      end
    end

    describe 'Remove' do
      it do
        r = described_class.new('MVP', issue_list(issue_a, issue_b, issue_c))
        r = r.remove_issue(issue_b)
        expect(r).to eq described_class.new('MVP', issue_list(issue_a, issue_c))
      end
    end

    describe 'Change issue priority' do
      it do
        r = described_class.new('MVP', issue_list(issue_a, issue_b, issue_c))
        r = r.change_issue_priority(issue_c, issue_a)
        expect(r).to eq described_class.new('MVP', issue_list(issue_c, issue_a, issue_b))
      end
    end

    describe 'Change name' do
      it do
        r = described_class.new('MVP', issue_list(issue_a, issue_b, issue_c))
        r = r.change_name('1st Release')
        expect(r).to eq described_class.new('1st Release', issue_list(issue_a, issue_b, issue_c))
      end
    end

    describe 'Check to include issue' do
      it { expect(described_class.new('R', issue_list(issue_a, issue_b, issue_c))).to be_include(issue_b) }
      it { expect(described_class.new('R', issue_list(issue_a, issue_c))).to_not be_include(issue_b) }
    end

    describe 'Query to removable' do
      it { expect(described_class.new('R', issue_list(issue_a))).to_not be_can_remove }
      it { expect(described_class.new('R', issue_list)).to be_can_remove }
    end
  end
end
