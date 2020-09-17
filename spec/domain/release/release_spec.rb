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
        release = described_class.new(product_id, 'MVP', [])

        aggregate_failures do
          expect(release.product_id).to eq product_id
          expect(release.title).to eq 'MVP'
          expect(release.items).to be_empty
        end
      end
    end

    describe 'Modify title' do
      it do
        old = described_class.new(product_id, 'OLD_TITLE', [item_a])

        new = old.modify_title('NEW_TITLE')

        expect(new.title).to eq 'NEW_TITLE'
        expect(new.items).to eq [item_a]
      end
    end

    describe 'Add & Remove item' do
      it do
        release = described_class
          .new(product_id, 'MVP', [])
          .yield_self { |r| r.add_item(item_a) }
          .yield_self { |r| r.add_item(item_b) }
          .yield_self { |r| r.add_item(item_c) }
        expect(release.items).to eq [item_a, item_b, item_c]
      end

      it do
        release = described_class
          .new(product_id, 'MVP', [])
          .yield_self { |r| r.add_item(item_a) }
          .yield_self { |r| r.add_item(item_b) }
          .yield_self { |r| r.add_item(item_c) }
          .yield_self { |r| r.remove_item(item_b) }
        expect(release.items).to eq [item_a, item_c]
      end
    end

    describe 'Swap priorities' do
      before do
        @release = described_class.new(
          product_id,
          'MVP',
          [item_a, item_b, item_c, item_d, item_e]
        )
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
