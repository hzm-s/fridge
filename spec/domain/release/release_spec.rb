# typed: false
require 'domain_helper'

module Release
  RSpec.describe Release do
    let(:item_a) { Pbi::Id.create }
    let(:item_b) { Pbi::Id.create }
    let(:item_c) { Pbi::Id.create }
    let(:item_d) { Pbi::Id.create }
    let(:item_e) { Pbi::Id.create }

    describe 'Create' do
      it do
        release = described_class.create('MVP')

        aggregate_failures do
          expect(release.id).to_not be_nil
          expect(release.title).to eq 'MVP'
          expect(release.items).to be_empty
        end
      end
    end

    describe 'Add & Remove item' do
      let(:release) { described_class.create('MVP') }

      before do
        release.add_item(item_a)
        release.add_item(item_b)
        release.add_item(item_c)
      end

      it do
        expect(release.items).to eq ItemList.new([item_a, item_b, item_c])
      end

      it do
        release.remove_item(item_b)
        expect(release.items).to eq ItemList.new([item_a, item_c])
      end
    end

    describe 'Modify title' do
      it do
        release = described_class.create('OLD_TITLE')

        release.modify_title('NEW_TITLE')

        expect(release.title).to eq 'NEW_TITLE'
        expect(release.items).to be_empty
      end
    end

    describe 'can_remove?' do
      it do
        release = described_class.create('MVP')
        expect(release).to be_can_remove
      end

      it do
        release = described_class.create('MVP')
        release.add_item(item_a)
        expect(release).to_not be_can_remove
      end
    end

    describe 'Swap priorities' do
      it do
        release = described_class.create('MVP')
        [item_a, item_b, item_c, item_d, item_e].each do |item|
          release.add_item(item)
        end

        release.swap_priorities(item_a, item_e)
        expect(release.items).to eq ItemList.new([item_b, item_c, item_d, item_e, item_a])

        release.swap_priorities(item_d, item_b)
        expect(release.items).to eq ItemList.new([item_d, item_b, item_c, item_e, item_a])

        release.swap_priorities(item_b, item_e)
        expect(release.items).to eq ItemList.new([item_d, item_c, item_e, item_b, item_a])
      end
    end
  end
end
