# typed: false
require 'domain_helper'

module Plan
  RSpec.describe Plan do
    let(:product_id) { Product::Id.create }
    let(:plan) { described_class.create(product_id) }

    let(:pbi_a) { Pbi::Id.create }
    let(:pbi_b) { Pbi::Id.create }
    let(:pbi_c) { Pbi::Id.create }
    let(:pbi_d) { Pbi::Id.create }
    let(:pbi_e) { Pbi::Id.create }

    describe 'add_item' do
      it do
        plan.add_item(pbi_a)
        plan.add_item(pbi_b)
        plan.add_release('R2')
        plan.add_item(pbi_c)
        expect(plan.items).to eq [[pbi_a, pbi_b], [pbi_c]]
      end
    end

    describe 'move item in release' do
      it do
        plan.add_item(pbi_a)
        plan.add_item(pbi_b)
        plan.add_item(pbi_c)
        plan.add_release('R2')
        plan.add_item(pbi_d)
        plan.add_item(pbi_e)

        plan.move_item(pbi_a, 1, 2)
        expect(plan.items).to eq [[pbi_b, pbi_a, pbi_c], [pbi_d, pbi_e]]

        plan.move_item(pbi_e, 2, 1)
        expect(plan.items).to eq [[pbi_b, pbi_a, pbi_c], [pbi_e, pbi_d]]
      end
    end

    describe 'move item to other release' do
      it do
        plan.add_item(pbi_a)
        plan.add_item(pbi_b)
        plan.add_item(pbi_c)
        plan.add_release('R2')
        plan.add_item(pbi_d)
        plan.add_item(pbi_e)

        plan.move_item(pbi_d, 1, 2)
        expect(plan.items).to eq [[pbi_a, pbi_d, pbi_b, pbi_c], [pbi_e]]

        plan.move_item(pbi_e, 1, 4)
        expect(plan.items).to eq [[pbi_a, pbi_d, pbi_b, pbi_e, pbi_c], []]

        plan.move_item(pbi_c, 2, 1)
        expect(plan.items).to eq [[pbi_a, pbi_d, pbi_b, pbi_e], [pbi_c]]

        plan.move_item(pbi_c, 1, 5)
        expect(plan.items).to eq [[pbi_a, pbi_d, pbi_b, pbi_e, pbi_c], []]
      end
    end

    describe 'change release title' do
      it do
        plan.add_release('R2')
        plan.add_release('R3')

        plan.change_release_title(1, 'MVP')

        expect(plan.release(1).title).to eq 'MVP'
      end
    end

    describe 'remove release' do
      it do
        plan.add_item(pbi_a)
        plan.add_release('R2')
        plan.add_item(pbi_b)

        expect { plan.remove_release(2) }.to raise_error(ReleaseContainsItem)

        plan.remove_item(pbi_b)
        plan.remove_release(2)
        expect(plan.items).to eq [[pbi_a]]

        plan.remove_item(pbi_a)
        expect { plan.remove_release(1) }.to raise_error(AtLeastOneReleaseIsRequired)
      end
    end
  end
end
