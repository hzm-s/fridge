# typed: false
require 'domain_helper'

module Issue
  RSpec.describe List do
    let(:issue_a) { Id.create }
    let(:issue_b) { Id.create }
    let(:issue_c) { Id.create }
    let(:issue_d) { Id.create }
    let(:issue_e) { Id.create }

    describe 'Append' do
      it do
        list = described_class.new([])
          .append(issue_a).append(issue_b).append(issue_c)
        expect(list).to eq described_class.new([issue_a, issue_b, issue_c])
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

    describe 'Fetch item by index' do
      it do
        list = described_class.new([issue_a, issue_b, issue_c, issue_d, issue_e])

        aggregate_failures do
          expect(list.index_of(0)).to eq issue_a
          expect(list.index_of(4)).to eq issue_e
          expect{ list.index_of(5) }.to raise_error(NotFound)
        end
      end
    end
  end
end
