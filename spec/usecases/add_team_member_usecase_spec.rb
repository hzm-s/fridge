# typed: false
require 'rails_helper'

RSpec.describe AddTeamMemberUsecase do
  let!(:product_id) { create_product(role: Team::Role::Developer).id }

  it do
    new_user = register_user
    described_class.perform(product_id, new_user.id, Team::Role::ProductOwner)

    product = ProductRepository::AR.find_by_id(product_id)
    new_member = product.team_member(new_user.id)

    expect(new_member.role).to eq Team::Role::ProductOwner
  end
end
