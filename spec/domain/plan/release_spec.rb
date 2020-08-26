# typed: false
require 'domain_helper'

module Plan
  RSpec.describe Release do
    let(:product_id) { Product::Id.create }
    let(:item_a) { Feature::Id.create }
    let(:item_b) { Feature::Id.create }
    let(:item_c) { Feature::Id.create }

    describe 'Create' do
      it do
        release = described_class.create('MVP')

        expect(release.title).to eq 'MVP'
        expect(release.items).to be_empty
      end
    end

    describe 'Add & Remove item' do
      let(:release) { described_class.create('Icebox') }

      it do
        release.add_item(item_a)
        expect(release.items).to match_array [item_a]
      end
    end
  end
end
__END__

    describe 'remove_item' do
      it do
        release.add_item(item_a)
        release.add_item(item_b)
        release.add_item(item_c)

        release.remove_item(item_b)

        expect(release.items).to match_array [item_a, item_c]
      end
    end

    describe 'modify title' do
      it do
        release.add_item(item_a)
        release.add_item(item_b)
        release.add_item(item_c)

        release.modify_title('NEW_TITLE')

        expect(release.title).to eq 'NEW_TITLE'
        expect(release.items).to match_array [item_a, item_b, item_c]
      end
    end

    describe 'can_remove?' do
      it do
        expect(release).to be_can_remove
      end

      it do
        release.add_item(item_a)
        expect(release).to_not be_can_remove
      end
    end
  end
end
