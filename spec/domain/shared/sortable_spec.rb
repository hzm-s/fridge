# typed: false
require 'domain_helper'

module Shared
  RSpec.describe SortableList do
    let(:item_a) { Pbi::Id.create }
    let(:item_b) { Pbi::Id.create }
    let(:item_c) { Pbi::Id.create }
    let(:item_d) { Pbi::Id.create }
    let(:item_e) { Pbi::Id.create }

    describe 'Append' do
      it do
        list = described_class.new([])
          .append(item_a).append(item_b).append(item_c)
        expect(list).to eq described_class.new([item_a, item_b, item_c])
      end
    end

    describe 'Remove' do
      it do
        list = described_class.new([item_a, item_b, item_c]).remove(item_b)
        expect(list).to eq described_class.new([item_a, item_c])
      end
    end

    describe 'Empty?' do
      it { expect(described_class.new([])).to be_empty }
      it { expect(described_class.new([item_a])).to_not be_empty }
    end

    describe 'Swap' do
      before do
        @list = described_class.new([item_a, item_b, item_c, item_d, item_e])
      end

      it do
        @list = @list.swap(item_a, item_a)
        expect(@list).to eq described_class.new([item_a, item_b, item_c, item_d, item_e])
      end

      it do
        @list = @list.swap(item_c, item_b)
        expect(@list).to eq described_class.new([item_a, item_c, item_b, item_d, item_e])
      end

      it do
        @list = @list.swap(item_e, item_a)
        expect(@list).to eq described_class.new([item_e, item_a, item_b, item_c, item_d])
      end

      it do
        @list = @list.swap(item_c, item_d)
        expect(@list).to eq described_class.new([item_a, item_b, item_d, item_c, item_e])
      end

      it do
        @list = @list.swap(item_a, item_e)
        expect(@list).to eq described_class.new([item_b, item_c, item_d, item_e, item_a])
      end
    end

    describe 'Check to include item' do
      it { expect(described_class.new([item_a, item_b, item_c])).to be_include(item_b) }
      it { expect(described_class.new([item_a, item_b, item_c])).to_not be_include(item_d) }
    end

    describe 'Fetch item by index' do
      it do
        list = described_class.new([item_a, item_b, item_c, item_d, item_e])

        aggregate_failures do
          expect(list.index_of(0)).to eq item_a
          expect(list.index_of(4)).to eq item_e
          expect{ list.index_of(5) }.to raise_error SortableList::NotFound
        end
      end
    end
  end
end
