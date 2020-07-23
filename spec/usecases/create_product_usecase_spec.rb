# typed: false
require 'rails_helper'

RSpec.describe CreateProductUsecase do
  let(:user) { register_user }

  it do
    product_id = described_class.perform(user.id, Team::Role::ProductOwner, 'fridge', 'DESC')
    product = ProductRepository::AR.find_by_id(product_id)
    member = product.member(user.id)

    aggregate_failures do
      expect(product.name).to eq 'fridge'
      expect(product.description).to eq 'DESC'

      expect(member.user_id).to eq user.id
      expect(member.role.to_s).to eq 'product_owner'
    end
  end
end
