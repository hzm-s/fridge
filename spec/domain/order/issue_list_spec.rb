# typed: false
require 'domain_helper'

module Order
  RSpec.describe List do
    let(:issue_a) { Issue::Id.create }
    let(:issue_b) { Issue::Id.create }
    let(:issue_c) { Issue::Id.create }
    let(:issue_d) { Issue::Id.create }
    let(:issue_e) { Issue::Id.create }

    describe 'Append & Remove item' do
      it do
        list = described_class.new([])
        list = list.append(issue_a)
        list = list.append(issue_b)
        list = list.append(issue_c)

        expect(list.to_a).to eq [issue_a, issue_b, issue_c]
      end

      it do
        list = described_class.new([issue_a, issue_b, issue_c])

        list = list.remove_item(issue_b)

        expect(list.to_a).to eq [issue_a, issue_c]
      end
    end

    describe 'Empty?' do
      it do
        expect(described_class.new([])).to be_empty
      end

      it do
        expect(described_class.new([issue_a])).to_not be_empty
      end
    end

    describe 'Swap priorities' do
      before do
        @list = described_class.new([issue_a, issue_b, issue_c, issue_d, issue_e])
      end

      it do
        @list = @list.swap_priorities(issue_a, issue_a)
        expect(@list.to_a).to eq [issue_a, issue_b, issue_c, issue_d, issue_e]
      end

      it do
        @list = @list.swap_priorities(issue_c, issue_b)
        expect(@list.to_a).to eq [issue_a, issue_c, issue_b, issue_d, issue_e]
      end

      it do
        @list = @list.swap_priorities(issue_e, issue_a)
        expect(@list.to_a).to eq [issue_e, issue_a, issue_b, issue_c, issue_d]
      end

      it do
        @list = @list.swap_priorities(issue_c, issue_d)
        expect(@list.to_a).to eq [issue_a, issue_b, issue_d, issue_c, issue_e]
      end

      it do
        @list = @list.swap_priorities(issue_a, issue_e)
        expect(@list.to_a).to eq [issue_b, issue_c, issue_d, issue_e, issue_a]
      end
    end
  end
end
