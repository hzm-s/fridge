# typed: false
require 'rails_helper'

RSpec.describe CreateProductUsecase do
  let(:user_account) { register_person }

  it do
    product_id = described_class.perform(user_account.person_id, Team::Role::ProductOwner, 'fridge', 'DESC')
    product = ProductRepository::AR.find_by_id(product_id)
    member = product.team_member(user_account.person_id)

    aggregate_failures do
      expect(product.name).to eq 'fridge'
      expect(product.description).to eq 'DESC'

      expect(member.person_id).to eq user_account.person_id
      expect(member.role.to_s).to eq 'product_owner'
    end
  end
end
