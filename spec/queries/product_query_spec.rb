# typed: false
require 'rails_helper'

RSpec.describe ProductQuery do
  let(:person_a) { sign_up_as_person }
  let(:person_b) { sign_up_as_person }

  let!(:product_x) { create_product(person_id: person_a.id, role: Team::Role::Developer) }
  let!(:product_y) { create_product(person_id: person_b.id, role: Team::Role::ProductOwner) }

  before do
    add_team_member(product_y.id, dev_member(person_a.id))
  end

  context 'given user_a' do
    it do
      products = described_class.call(person_a.id)
      expect(products.map(&:id)).to match_array [product_x, product_y].map(&:id).map(&:to_s)
    end
  end

  context 'given user_b' do
    it do
      products = described_class.call(person_b.id)
      expect(products.map(&:id)).to match_array [product_y].map(&:id).map(&:to_s)
    end
  end
end
