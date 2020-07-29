# typed: false
require 'rails_helper'

RSpec.describe ProductQuery do
  let(:user_a) { register_user }
  let(:user_b) { register_user }

  let!(:product_x) { create_product(user_id: user_a.id, role: Team::Role::Developer) }
  let!(:product_y) { create_product(user_id: user_b.id, role: Team::Role::ProductOwner) }

  before do
    add_team_member(product_y.id, dev_member(user_a.id))
  end

  context 'given user_a' do
    it do
      products = described_class.call(user_a.id)
      expect(products.map(&:id)).to match_array [product_x, product_y].map(&:id).map(&:to_s)
    end
  end

  context 'given user_b' do
    it do
      products = described_class.call(user_b.id)
      expect(products.map(&:id)).to match_array [product_y].map(&:id).map(&:to_s)
    end
  end
end
