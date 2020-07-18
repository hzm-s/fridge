# typed: false
require 'rails_helper'

module Pbi
  RSpec.describe Order do
    let(:product) { Product::Product.create('fridge') }

    let(:pbi_a) { Pbi::Item.create(product.id, Pbi::Content.from_string('AAA')) }
    let(:pbi_b) { Pbi::Item.create(product.id, Pbi::Content.from_string('BBB')) }
    let(:pbi_c) { Pbi::Item.create(product.id, Pbi::Content.from_string('CCC')) }
    let(:pbi_d) { Pbi::Item.create(product.id, Pbi::Content.from_string('DDD')) }
    let(:pbi_e) { Pbi::Item.create(product.id, Pbi::Content.from_string('EEE')) }

    describe 'append an item' do
      it do
        order = described_class.create(product.id)

        order.append(pbi_a)
        order.append(pbi_b)
        order.append(pbi_c)

        expect(order.to_a).to eq [pbi_a, pbi_b, pbi_c].map(&:id)
      end
    end

    describe 'delete an item' do
      it do
        order = described_class.create(product.id)

        order.append(pbi_a)
        order.append(pbi_b)
        order.append(pbi_c)

        order.delete(pbi_b.id)

        expect(order.to_a).to eq [pbi_a, pbi_c].map(&:id)
      end
    end

    describe 'sort' do
      let!(:order) { described_class.create(product.id) }

      before do
        order.append(pbi_a)
        order.append(pbi_b)
        order.append(pbi_c)
        order.append(pbi_d)
        order.append(pbi_e)
      end

      it do
        order.move_item_to(pbi_a.id, 1)
        expect(order.to_a).to eq [pbi_a, pbi_b, pbi_c, pbi_d, pbi_e].map(&:id)
      end

      it do
        order.move_item_to(pbi_e.id, 1)
        expect(order.to_a).to eq [pbi_e, pbi_a, pbi_b, pbi_c, pbi_d].map(&:id)
      end

      it do
        order.move_item_to(pbi_a.id, 5)
        expect(order.to_a).to eq [pbi_b, pbi_c, pbi_d, pbi_e, pbi_a].map(&:id)
      end

      it do
        order.move_item_to(pbi_a.id, 2)
        expect(order.to_a).to eq [pbi_b, pbi_a, pbi_c, pbi_d, pbi_e].map(&:id)
      end

      it do
        order.move_item_to(pbi_e.id, 4)
        expect(order.to_a).to eq [pbi_a, pbi_b, pbi_c, pbi_e, pbi_d].map(&:id)
      end

      it do
        order.move_item_to(pbi_b.id, 5)
        expect(order.to_a).to eq [pbi_a, pbi_c, pbi_d, pbi_e, pbi_b].map(&:id)
      end

      it do
        order.move_item_to(pbi_d.id, 1)
        expect(order.to_a).to eq [pbi_d, pbi_a, pbi_b, pbi_c, pbi_e].map(&:id)
      end

      it do
        order.move_item_to(pbi_b.id, 3)
        expect(order.to_a).to eq [pbi_a, pbi_c, pbi_b, pbi_d, pbi_e].map(&:id)
      end

      it do
        order.move_item_to(pbi_d.id, 3)
        expect(order.to_a).to eq [pbi_a, pbi_b, pbi_d, pbi_c, pbi_e].map(&:id)
      end
    end
  end
end
