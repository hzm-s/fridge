# typed: false
require 'rails_helper'

RSpec.describe 'team_members' do
  let!(:founder) { sign_up }
  let!(:new_member) { sign_up }
  let!(:product) { create_product(user_id: User::Id.from_string(founder.id), role: Team::Role::Developer) }

  describe '#create' do
    before { sign_in(new_member) }

    it do
      params = { role: 'product_owner' }

      post product_team_members_path(product_id: product.id), params: params

      member = Dao::TeamMember.find_by(dao_user_id: new_member.id)
      expect(member.role).to eq 'product_owner'
    end
  end
end
