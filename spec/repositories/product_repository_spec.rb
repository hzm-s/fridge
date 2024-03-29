# typed: false
require 'rails_helper'

describe ProductRepository::AR do
  describe 'Add' do
    it do
      product = Product::Product.create(name('abc'), s_sentence('xyz'))

      described_class.store(product)
      stored = described_class.find_by_id(product.id)

      aggregate_failures do
        expect(stored.name).to eq product.name
        expect(stored.description).to eq product.description
      end
    end
  end
end
