require 'rails_helper'

module Pbi
  RSpec.describe Order do
    let(:product) { Product::Product.create('fridge') }

    let(:pbi_a) { Pbi::Item.create(product.id, Pbi::Content.from_string('AAA')) }
    let(:pbi_b) { Pbi::Item.create(product.id, Pbi::Content.from_string('BBB')) }
    let(:pbi_c) { Pbi::Item.create(product.id, Pbi::Content.from_string('CCC')) }

    describe 'append and position' do
      it do
        order = described_class.create(product.id)

        order.append(pbi_a)
        order.append(pbi_b)
        order.append(pbi_c)

        expect(order.position(pbi_a.id)).to eq 0
        expect(order.position(pbi_b.id)).to eq 1
        expect(order.position(pbi_c.id)).to eq 2
      end
    end
  end
end
