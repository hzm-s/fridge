# typed: false
require 'domain_helper'

module Release
  RSpec.describe IssueList do
    let(:issue_a) { Issue::Id.create }
    let(:issue_b) { Issue::Id.create }
    let(:issue_c) { Issue::Id.create }
    let(:issue_d) { Issue::Id.create }
    let(:issue_e) { Issue::Id.create }

    describe 'Append' do
      it do
        list = described_class.new([])
          .append(issue_a).append(issue_b).append(issue_c)
        expect(list).to eq described_class.new([issue_a, issue_b, issue_c])
      end
    end

    describe 'Add to first' do
      it do
        list = described_class.new([])
        expect(list.add_to_first(issue_a)).to eq described_class.new([issue_a])
      end

      it do
        list = described_class.new([issue_a, issue_b])
        expect(list.add_to_first(issue_c)).to eq described_class.new([issue_c, issue_a, issue_b])
      end
    end

    describe 'Remove' do
      it do
        list = described_class.new([issue_a, issue_b, issue_c]).remove(issue_b)
        expect(list).to eq described_class.new([issue_a, issue_c])
      end
    end

    describe 'Empty?' do
      it { expect(described_class.new([])).to be_empty }
      it { expect(described_class.new([issue_a])).to_not be_empty }
    end

    describe 'Swap' do
      before do
        @list = described_class.new([issue_a, issue_b, issue_c, issue_d, issue_e])
      end

      it do
        @list = @list.swap(issue_a, issue_a)
        expect(@list).to eq described_class.new([issue_a, issue_b, issue_c, issue_d, issue_e])
      end

      it do
        @list = @list.swap(issue_c, issue_b)
        expect(@list).to eq described_class.new([issue_a, issue_c, issue_b, issue_d, issue_e])
      end

      it do
        @list = @list.swap(issue_e, issue_a)
        expect(@list).to eq described_class.new([issue_e, issue_a, issue_b, issue_c, issue_d])
      end

      it do
        @list = @list.swap(issue_c, issue_d)
        expect(@list).to eq described_class.new([issue_a, issue_b, issue_d, issue_c, issue_e])
      end

      it do
        @list = @list.swap(issue_a, issue_e)
        expect(@list).to eq described_class.new([issue_b, issue_c, issue_d, issue_e, issue_a])
      end
    end

    describe 'Check to include issue' do
      it { expect(described_class.new([issue_a, issue_b, issue_c])).to be_include(issue_b) }
      it { expect(described_class.new([issue_a, issue_b, issue_c])).to_not be_include(issue_d) }
    end

    describe 'Check to have same issue' do
      it do
        a = described_class.new([])
        b = described_class.new([])
        expect(a.have_same_issue?(b)).to be false
      end

      it do
        a = described_class.new([issue_a])
        b = described_class.new([issue_a])
        expect(a.have_same_issue?(b)).to be true
      end

      it do
        a = described_class.new([issue_a, issue_b])
        b = described_class.new([issue_c, issue_d])
        expect(a.have_same_issue?(b)).to be false
      end

      it do
        a = described_class.new([issue_a, issue_b, issue_c])
        b = described_class.new([issue_c, issue_d, issue_e])
        expect(a.have_same_issue?(b)).to be true
      end

      it do
        a = described_class.new([issue_a, issue_b, issue_c])
        b = described_class.new([issue_b, issue_c, issue_a])
        expect(a.have_same_issue?(b)).to be true
      end

      it do
        a = described_class.new([issue_a])
        b = described_class.new([Issue::Id.from_string(issue_a.to_s)])
        expect(a.have_same_issue?(b)).to be true
      end
    end
  end
end
