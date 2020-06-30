require 'rails_helper'

module Product
  RSpec.describe BacklogItemOrder do
    let(:product) { Product.new('fridge') }

    let(:pbi_a) { BacklogItem.create('A') }
    let(:pbi_b) { BacklogItem.create('B') }
    let(:pbi_c) { BacklogItem.create('C') }

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
