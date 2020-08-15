# typed: false
require 'domain_helper'

module Release
  RSpec.describe Release do
    let(:product_id) { Product::Id.create }
    let(:pbi_a) { Pbi::Id.create }
    let(:pbi_b) { Pbi::Id.create }
    let(:pbi_c) { Pbi::Id.create }
    let(:pbi_d) { Pbi::Id.create }
    let(:pbi_e) { Pbi::Id.create }

    let(:release) { described_class.create(product_id, 'Icebox') }

    describe 'create' do
      it do
        release = described_class.create(product_id, 'MVP')

        expect(release.title).to eq 'MVP'
        expect(release.items).to be_empty
      end
    end

    describe 'add_item' do
      it do
        release.add_item(pbi_a)
        expect(release.items).to eq [pbi_a]
      end
    end

    describe 'remove_item' do
      it do
        release.add_item(pbi_a)
        release.add_item(pbi_b)
        release.add_item(pbi_c)
        release.remove_item(pbi_b)
        expect(release.items).to eq [pbi_a, pbi_c]
      end
    end

    describe 'sort' do
      before do
        release.add_item(pbi_a)
        release.add_item(pbi_b)
        release.add_item(pbi_c)
        release.add_item(pbi_d)
        release.add_item(pbi_e)
      end

      it do
        release.sort_item(pbi_a, 1)
        expect(release.items).to eq [pbi_a, pbi_b, pbi_c, pbi_d, pbi_e]
      end

      it do
        release.sort_item(pbi_e, 5)
        expect(release.items).to eq [pbi_a, pbi_b, pbi_c, pbi_d, pbi_e]
      end

      it do
        release.sort_item(pbi_c, 3)
        expect(release.items).to eq [pbi_a, pbi_b, pbi_c, pbi_d, pbi_e]
      end

      it do
        release.sort_item(pbi_a, 5)
        expect(release.items).to eq [pbi_b, pbi_c, pbi_d, pbi_e, pbi_a]
      end

      it do
        release.sort_item(pbi_e, 1)
        expect(release.items).to eq [pbi_e, pbi_a, pbi_b, pbi_c, pbi_d]
      end

      it do
        release.sort_item(pbi_b, 4)
        expect(release.items).to eq [pbi_a, pbi_c, pbi_d, pbi_b, pbi_e]
      end

      it do
        release.sort_item(pbi_d, 2)
        expect(release.items).to eq [pbi_a, pbi_d, pbi_b, pbi_c, pbi_e]
      end
    end

    describe 'change title' do
      it do
        release.add_item(pbi_a)
        release.add_item(pbi_b)
        release.add_item(pbi_c)
        release.change_title('NEW_TITLE')

        expect(release.title).to eq 'NEW_TITLE'
        expect(release.items).to eq [pbi_a, pbi_b, pbi_c]
      end
    end

    describe 'remove availability' do
      it do
        expect(release).to be_can_remove
      end

      it do
        release.add_item(pbi_a)
        expect(release).to_not be_can_remove
      end
    end
  end
end
