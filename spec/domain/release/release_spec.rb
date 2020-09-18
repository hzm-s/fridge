# typed: false
require 'domain_helper'

module Release
  RSpec.describe Release do
    let(:product_id) { Product::Id.create }
    let(:item_a) { Issue::Id.create }
    let(:item_b) { Issue::Id.create }
    let(:item_c) { Issue::Id.create }
    let(:item_d) { Issue::Id.create }
    let(:item_e) { Issue::Id.create }

    describe 'Create' do
      it do
        release = described_class.create(product_id, 'MVP')

        aggregate_failures do
          expect(release.id).to_not be_nil
          expect(release.product_id).to eq product_id
          expect(release.title).to eq 'MVP'
          expect(release.items).to eq ItemList.new([])
        end
      end
    end

    describe 'Modify title' do
      it do
        release = described_class.create(product_id, 'OLD_TITLE')

        release.modify_title('NEW_TITLE')

        expect(release.title).to eq 'NEW_TITLE'
      end
    end

    describe 'Add & Remove item' do
      it do
        release = described_class.create(product_id, 'MVP')
        release.add_item(item_a)
        release.add_item(item_b)
        release.add_item(item_c)

        expect(release.items).to eq ItemList.new([item_a, item_b, item_c])
      end

      it do
        release = described_class.create(product_id, 'MVP')
        release.add_item(item_a)
        release.add_item(item_b)
        release.add_item(item_c)
        release.remove_item(item_b)

        expect(release.items).to eq ItemList.new([item_a, item_c])
      end
    end

    describe 'Swap priorities' do
      it do
        release = described_class.create(product_id, 'MVP')
        release.add_item(item_a)
        release.add_item(item_b)
        release.add_item(item_c)
        release.add_item(item_d)
        release.add_item(item_e)

        release.swap_priorities(item_a, item_d)

        expect(release.items).to eq ItemList.new([item_b, item_c, item_d, item_a, item_e])
      end
    end
  end
end
