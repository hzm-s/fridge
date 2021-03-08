# typed: false
require 'rails_helper'

RSpec.describe ReleaseRepository::AR do
  let(:product_id) { Product::Id.create }

  before do
    Dao::Product.create!(id: product_id, name: 'p')
  end

  describe 'Query next number' do
    it do
      expect(described_class.next_number).to eq 1
      Dao::Release.create!(dao_product_id: product_id, number: 1)
      Dao::Release.create!(dao_product_id: product_id, number: 2)
      Dao::Release.create!(dao_product_id: product_id, number: 3)
      Dao::Release.create!(dao_product_id: product_id, number: 5)
      Dao::Release.create!(dao_product_id: product_id, number: 6)
      expect(described_class.next_number).to eq 7
    end
  end

  describe 'Append' do
    it do
    end
  end
end
