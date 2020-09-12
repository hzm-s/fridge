# typed: false
require 'domain_helper'

module Plan
  RSpec.describe Release do
    let(:item_a) { Pbi::Id.create }
    let(:item_b) { Pbi::Id.create }
    let(:item_c) { Pbi::Id.create }
    let(:item_d) { Pbi::Id.create }
    let(:item_e) { Pbi::Id.create }

    let(:seq) { ReleaseSequence.new(1) }

    describe 'Create' do
      it do
        release = described_class.new(seq, 'MVP', ItemList.new([]))

        expect(release.title).to eq 'MVP'
        expect(release.items).to be_empty
      end
    end

    describe 'Add & Remove item' do
      before do
        @release = described_class.new(seq, 'R', ItemList.new([]))
        @release = @release.add_item(item_a)
        @release = @release.add_item(item_b)
        @release = @release.add_item(item_c)
      end

      it do
        expect(@release.items).to eq ItemList.new([item_a, item_b, item_c])
      end

      it do
        @release = @release.remove_item(item_b)

        expect(@release.items).to eq ItemList.new([item_a, item_c])
      end
    end

    describe 'Modify title' do
      it do
        release = described_class.new(seq, 'OLD_TITLE', ItemList.new([]))

        release = release.modify_title('NEW_TITLE')

        expect(release.title).to eq 'NEW_TITLE'
        expect(release.items).to be_empty
      end
    end

    describe 'can_remove?' do
      it do
        release = described_class.new(seq, 'MVP', ItemList.new([]))
        expect(release).to be_can_remove
      end

      it do
        release = described_class.new(seq, 'MVP', ItemList.new([item_a]))
        expect(release).to_not be_can_remove
      end
    end

    describe 'Swap priorities' do
      it do
        release = described_class.new(
          seq,
          'Icebox',
          ItemList.new([item_a, item_b, item_c, item_d, item_e])
        )

        release = release.swap_priorities(item_a, item_e)
        expect(release.items).to eq ItemList.new([item_b, item_c, item_d, item_e, item_a])

        release = release.swap_priorities(item_d, item_b)
        expect(release.items).to eq ItemList.new([item_d, item_b, item_c, item_e, item_a])

        release = release.swap_priorities(item_b, item_e)
        expect(release.items).to eq ItemList.new([item_d, item_c, item_e, item_b, item_a])
      end
    end
  end
end
