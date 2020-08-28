# typed: false
require 'domain_helper'

module Plan
  RSpec.describe Release do
    let(:product_id) { Product::Id.create }
    let(:item_a) { Pbi::Id.create }
    let(:item_b) { Pbi::Id.create }
    let(:item_c) { Pbi::Id.create }
    let(:item_d) { Pbi::Id.create }
    let(:item_e) { Pbi::Id.create }

    describe 'Create' do
      it do
        release = described_class.create('MVP')

        expect(release.title).to eq 'MVP'
        expect(release.items).to be_empty
      end
    end

    describe 'Add & Remove item' do
      let(:release) { described_class.create('Icebox') }

      before do
        release.add_item(item_a)
        release.add_item(item_b)
        release.add_item(item_c)
      end

      it do
        expect(release.items).to eq [item_a, item_b, item_c]
      end

      it do
        release.remove_item(item_b)

        expect(release.items).to eq [item_a, item_c]
      end
    end

    describe 'modify title' do
      it do
        release = described_class.create('OLD_TITLE')

        release.add_item(item_a)
        release.add_item(item_b)
        release.add_item(item_c)

        release.modify_title('NEW_TITLE')

        expect(release.title).to eq 'NEW_TITLE'
        expect(release.items).to eq [item_a, item_b, item_c]
      end
    end

    describe 'can_remove?' do
      let(:release) { described_class.create('MVP') }

      it do
        expect(release).to be_can_remove
      end

      it do
        release.add_item(item_a)

        expect(release).to_not be_can_remove
      end
    end

    describe 'Swap priorities' do
      let(:release) { described_class.create('Icebox') }

      before do
        release.add_item(item_a)
        release.add_item(item_b)
        release.add_item(item_c)
        release.add_item(item_d)
        release.add_item(item_e)
      end

      it do
        release.swap_priorities(item_c, item_b)
        expect(release.items).to eq [item_a, item_c, item_b, item_d, item_e]
      end

      it do
        release.swap_priorities(item_e, item_a)
        expect(release.items).to eq [item_e, item_a, item_b, item_c, item_d]
      end

      it do
        release.swap_priorities(item_c, item_d)
        expect(release.items).to eq [item_a, item_b, item_d, item_c, item_e]
      end

      it do
        release.swap_priorities(item_e, item_a)
        expect(release.items).to eq [item_e, item_a, item_b, item_c, item_d]
      end
    end
  end
end
