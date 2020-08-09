# typed: false
require 'domain_helper'

module Plan
  RSpec.describe Release do
    let(:release) { described_class.new }

    let(:pbi_a) { Pbi::Id.create }
    let(:pbi_b) { Pbi::Id.create }
    let(:pbi_c) { Pbi::Id.create }
    let(:pbi_d) { Pbi::Id.create }
    let(:pbi_e) { Pbi::Id.create }

    describe 'sort' do
      before do
        release.add(pbi_a)
        release.add(pbi_b)
        release.add(pbi_c)
        release.add(pbi_d)
        release.add(pbi_e)
      end

      it do
        release.move_item_to(pbi_a, 1)
        expect(release.to_a).to eq [pbi_a, pbi_b, pbi_c, pbi_d, pbi_e]
      end

      it do
        release.move_item_to(pbi_e, 5)
        expect(release.to_a).to eq [pbi_a, pbi_b, pbi_c, pbi_d, pbi_e]
      end

      it do
        release.move_item_to(pbi_c, 3)
        expect(release.to_a).to eq [pbi_a, pbi_b, pbi_c, pbi_d, pbi_e]
      end

      it do
        release.move_item_to(pbi_a, 5)
        expect(release.to_a).to eq [pbi_b, pbi_c, pbi_d, pbi_e, pbi_a]
      end

      it do
        release.move_item_to(pbi_e, 1)
        expect(release.to_a).to eq [pbi_e, pbi_a, pbi_b, pbi_c, pbi_d]
      end

      it do
        release.move_item_to(pbi_b, 4)
        expect(release.to_a).to eq [pbi_a, pbi_c, pbi_d, pbi_b, pbi_e]
      end

      it do
        release.move_item_to(pbi_d, 2)
        expect(release.to_a).to eq [pbi_a, pbi_d, pbi_b, pbi_c, pbi_e]
      end
    end
  end
end
