# typed: true
class App::OauthAccount < ApplicationRecord
  belongs_to :dao_user, class_name: 'Dao::User', foreign_key: :dao_user_id

  class << self
    def create_with_user(user_id, provider:, uid:)
      create!(dao_user_id: user_id, provider: provider, uid: uid)
    end

    def find_user_by_account(provider:, uid:)
      account = find_by(provider: provider, uid: uid)
      return nil unless account

      account.dao_user_id
    end

    def find_by_user_id(user_id)
      joins(:dao_user).find_by(dao_users: { id: user_id })
    end
  end
end
