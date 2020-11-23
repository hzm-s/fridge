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

    describe 'Swap' do
      it do
        r = described_class.new('MVP', issue_list(issue_a, issue_b, issue_c))
        r = r.swap_issues(issue_c, issue_a)
        expect(r).to eq described_class.new('MVP', issue_list(issue_c, issue_a, issue_b))
      end
    end
  end
end
