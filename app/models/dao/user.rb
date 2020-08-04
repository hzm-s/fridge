# typed: false
class Dao::User < ApplicationRecord
  has_one :oauth_account, class_name: 'App::OauthAccount', foreign_key: :dao_user_id, dependent: :destroy
  has_one :avatar, class_name: 'App::Avatar', foreign_key: :dao_user_id, dependent: :destroy
  has_many :team_members, class_name: 'Dao::TeamMember', foreign_key: :dao_user_id, dependent: :destroy

  def user_id_as_do
    User::Id.from_string(id)
  end
end
