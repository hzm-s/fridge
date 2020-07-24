# typed: false
require 'rails_helper'

RSpec.describe 'team_members' do
  let!(:user) { sign_up }
  let!(:product) { create_product(user_id: User::Id.from_string(user.id), role: Team::Role::Developer) }

  before { sign_in(user) }

  describe '#create' do
    it do
      other_user = register_user
      params = { form: { user_id: other_user.id, role: 'product_owner' } }

      expect {
        post product_team_members_path(product_id: product.id, format: :js), params: params
      }
        .to change { Dao::TeamMember.count }.by(1)
    end
  end
end
