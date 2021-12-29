# typed: false
require 'domain_helper'

module Product
  describe Product do
    describe 'Create product' do
      it do
        product = described_class.create(name('ABC'), s_sentence('DESC_ABC'))

        aggregate_failures do
          expect(product.id).to_not be_nil
          expect(product.name.to_s).to eq 'ABC'
          expect(product.description.to_s).to eq 'DESC_ABC'
        end
      end
    end
  end
end
