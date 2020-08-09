# typed: false
require 'domain_helper'

module Plan
  RSpec.describe Release do
    let(:pbi_a) { Pbi::Id.create }
    let(:pbi_b) { Pbi::Id.create }
    let(:pbi_c) { Pbi::Id.create }
    let(:pbi_d) { Pbi::Id.create }
    let(:pbi_e) { Pbi::Id.create }

    describe 'add' do
      it do
        release = described_class.new
        release = release.add(pbi_a)
        expect(release.items).to eq [pbi_a]
      end
    end

    describe 'remove' do
      it do
        release = described_class.new
        release = release.add(pbi_a)
        release = release.add(pbi_b)
        release = release.add(pbi_c)
        release = release.remove(pbi_b)
        expect(release.items).to eq [pbi_a, pbi_c]
      end
    end

    describe 'sort' do
      before do
        @release = described_class.new
        @release = @release.add(pbi_a)
        @release = @release.add(pbi_b)
        @release = @release.add(pbi_c)
        @release = @release.add(pbi_d)
        @release = @release.add(pbi_e)
      end

      it do
        @release = @release.move_to(pbi_a, 1)
        expect(@release.items).to eq [pbi_a, pbi_b, pbi_c, pbi_d, pbi_e]
      end

      it do
        @release = @release.move_to(pbi_e, 5)
        expect(@release.items).to eq [pbi_a, pbi_b, pbi_c, pbi_d, pbi_e]
      end

      it do
        @release = @release.move_to(pbi_c, 3)
        expect(@release.items).to eq [pbi_a, pbi_b, pbi_c, pbi_d, pbi_e]
      end

      it do
        @release = @release.move_to(pbi_a, 5)
        expect(@release.items).to eq [pbi_b, pbi_c, pbi_d, pbi_e, pbi_a]
      end

      it do
        @release = @release.move_to(pbi_e, 1)
        expect(@release.items).to eq [pbi_e, pbi_a, pbi_b, pbi_c, pbi_d]
      end

      it do
        @release = @release.move_to(pbi_b, 4)
        expect(@release.items).to eq [pbi_a, pbi_c, pbi_d, pbi_b, pbi_e]
      end

      it do
        @release = @release.move_to(pbi_d, 2)
        expect(@release.items).to eq [pbi_a, pbi_d, pbi_b, pbi_c, pbi_e]
      end
    end
  end
end
