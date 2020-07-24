# typed: false
require 'rails_helper'

RSpec.describe UsersForNewTeamMemberQuery do
  let!(:user_a) { Dao::User.find(register_user.id) }
  let!(:user_b) { Dao::User.find(register_user.id) }
  let!(:user_c) { Dao::User.find(register_user.id) }
  let!(:user_d) { Dao::User.find(register_user.id) }
  let!(:product_x) { create_product(user_id: User::Id.from_string(user_a.id)) }
  let!(:product_y) { create_product(user_id: User::Id.from_string(user_b.id)) }

  before do
    AddTeamMemberUsecase.perform(product_y.id, User::Id.from_string(user_a.id), Team::Role::Developer)
    AddTeamMemberUsecase.perform(product_y.id, User::Id.from_string(user_c.id), Team::Role::Developer)
  end

  it '対象プロダクトチームに所属していないユーザーを全て返すこと' do
    users = described_class.call(product_x.id.to_s)
    expect(users).to match_array [user_b, user_c, user_d]
  end

  it '対象プロダクトチームに所属していないユーザーを全て返すこと' do
    users = described_class.call(product_y.id.to_s)
    expect(users).to match_array [user_d]
  end
end
