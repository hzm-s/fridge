# typed: strict
class Dao::User < ApplicationRecord
  has_one :oauth_account, class_name: 'App::OauthAccount', foreign_key: :dao_user_id, dependent: :destroy
end
