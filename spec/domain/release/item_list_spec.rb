# typed: false
require 'domain_helper'

module Release
  RSpec.describe ItemList do
    let(:item_a) { Issue::Id.create }
    let(:item_b) { Issue::Id.create }
    let(:item_c) { Issue::Id.create }
    let(:item_d) { Issue::Id.create }
    let(:item_e) { Issue::Id.create }

    describe 'Add & Remove item' do
      it do
        items = described_class.new([])
        items = items.add_item(item_a)
        items = items.add_item(item_b)
        items = items.add_item(item_c)

        expect(items.to_a).to eq [item_a, item_b, item_c]
      end

      it do
        items = described_class.new([item_a, item_b, item_c])

        items = items.remove_item(item_b)

        expect(items.to_a).to eq [item_a, item_c]
      end
    end

    describe 'Empty?' do
      it do
        expect(described_class.new([])).to be_empty
      end

      it do
        expect(described_class.new([item_a])).to_not be_empty
      end
    end

    describe 'Swap priorities' do
      before do
        @items = described_class.new([item_a, item_b, item_c, item_d, item_e])
      end

      it do
        @items = @items.swap_priorities(item_a, item_a)
        expect(@items.to_a).to eq [item_a, item_b, item_c, item_d, item_e]
      end

      it do
        @items = @items.swap_priorities(item_c, item_b)
        expect(@items.to_a).to eq [item_a, item_c, item_b, item_d, item_e]
      end

      it do
        @items = @items.swap_priorities(item_e, item_a)
        expect(@items.to_a).to eq [item_e, item_a, item_b, item_c, item_d]
      end

      it do
        @items = @items.swap_priorities(item_c, item_d)
        expect(@items.to_a).to eq [item_a, item_b, item_d, item_c, item_e]
      end

      it do
        @items = @items.swap_priorities(item_a, item_e)
        expect(@items.to_a).to eq [item_b, item_c, item_d, item_e, item_a]
      end
    end
  end
end
