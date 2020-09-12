# typed: false
require 'domain_helper'

module Plan
  RSpec.describe Release do
    let(:item_a) { Pbi::Id.create }
    let(:item_b) { Pbi::Id.create }
    let(:item_c) { Pbi::Id.create }
    let(:item_d) { Pbi::Id.create }
    let(:item_e) { Pbi::Id.create }

    describe 'Create' do
      it do
        release = described_class.new('MVP', [])

        expect(release.title).to eq 'MVP'
        expect(release.items).to be_empty
      end
    end

    describe 'Add & Remove item' do
      before do
        @release = described_class.new('R', [])
        @release = @release.add_item(item_a)
        @release = @release.add_item(item_b)
        @release = @release.add_item(item_c)
      end

      it do
        expect(@release.items).to eq [item_a, item_b, item_c]
      end

      it do
        @release = @release.remove_item(item_b)

        expect(@release.items).to eq [item_a, item_c]
      end
    end

    describe 'modify title' do
      it do
        release = described_class.new('OLD_TITLE', [])

        release = release.modify_title('NEW_TITLE')

        expect(release.title).to eq 'NEW_TITLE'
        expect(release.items).to be_empty
      end
    end

    describe 'can_remove?' do
      let(:release) { described_class.new('MVP', []) }

      it do
        expect(release).to be_can_remove
      end

      it do
        added = release.add_item(item_a)

        expect(added).to_not be_can_remove
      end
    end

    describe 'Swap priorities' do
      before do
        @release = described_class.new('Icebox', [
          item_a,
          item_b,
          item_c,
          item_d,
          item_e,
        ])
      end

      it do
        @release = @release.swap_priorities(item_a, item_a)
        expect(@release.items).to eq [item_a, item_b, item_c, item_d, item_e]
      end

      it do
        @release = @release.swap_priorities(item_c, item_b)
        expect(@release.items).to eq [item_a, item_c, item_b, item_d, item_e]
      end

      it do
        @release = @release.swap_priorities(item_e, item_a)
        expect(@release.items).to eq [item_e, item_a, item_b, item_c, item_d]
      end

      it do
        @release = @release.swap_priorities(item_c, item_d)
        expect(@release.items).to eq [item_a, item_b, item_d, item_c, item_e]
      end

      it do
        @release = @release.swap_priorities(item_a, item_e)
        expect(@release.items).to eq [item_b, item_c, item_d, item_e, item_a]
      end
    end
  end
end
