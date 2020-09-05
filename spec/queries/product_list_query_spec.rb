# typed: false
require 'rails_helper'

RSpec.describe ProductListQuery do
  let!(:person_a) { sign_up_as_person }
  let!(:person_b) { sign_up_as_person }
  let!(:person_c) { sign_up_as_person }
  let!(:person_d) { sign_up_as_person }

  let!(:product_x) { create_product(owner: person_a.id, members: [dev_member(person_a.id), dev_member(person_c.id)]) }
  let!(:product_y) { create_product(owner: person_b.id, members: [dev_member(person_c.id)]) }

  context 'given user_a' do
    it do
      products = described_class.call(person_a.id)
      expect(products.map(&:id)).to match_array [product_x].map(&:id).map(&:to_s)
    end
  end

  context 'given user_b' do
    it do
      products = described_class.call(person_b.id)
      expect(products.map(&:id)).to match_array [product_y].map(&:id).map(&:to_s)
    end
  end

  context 'given user_c' do
    it do
      products = described_class.call(person_c.id)
      expect(products.map(&:id)).to match_array [product_x, product_y].map(&:id).map(&:to_s)
    end
  end

  context 'given user_d' do
    it do
      products = described_class.call(person_d.id)
      expect(products).to be_empty
    end
  end
end
