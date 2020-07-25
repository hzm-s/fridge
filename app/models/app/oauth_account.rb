# typed: true
class App::OauthAccount < ApplicationRecord
  belongs_to :dao_user, class_name: 'Dao::User', foreign_key: :dao_user_id

  class << self
    def create_for_user(user_id, account)
      create!(dao_user_id: user_id, provider: account[:provider], uid: account[:uid])
    end

    def find_user_id_by_account(account)
      find_by(provider: account[:provider], uid: account[:uid])&.dao_user_id
    end
  end
end
