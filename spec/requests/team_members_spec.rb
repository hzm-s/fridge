# typed: false
require 'rails_helper'

RSpec.describe 'team_members' do
  let!(:founder) { sign_up }
  let!(:new_member) { sign_up }
  let!(:product) { create_product(user_id: User::Id.from_string(founder.id), role: Team::Role::Developer) }

  describe '#new' do
    context 'when signed in' do
      before { sign_in(new_member) }

      it do
        get new_product_team_member_path(product_id: product.id)

        expect(response.body).to include 'product_owner'
        expect(response.body).to include 'developer'
        expect(response.body).to include 'scrum_master'
      end
    end

    context 'when NOT signed in' do
      it do
        get new_product_team_member_path(product_id: product.id)
        sign_in(new_member)
        follow_redirect!

        expect(response.body).to include 'product_owner'
        expect(response.body).to include 'developer'
        expect(response.body).to include 'scrum_master'
      end
    end
  end

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
