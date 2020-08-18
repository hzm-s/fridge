# typed: true
class App::UserAccount < ApplicationRecord
  belongs_to :dao_person, class_name: 'Dao::Person', foreign_key: :dao_person_id

  class << self
    def create_for_user(user_id, account)
      create!(dao_user_id: user_id, provider: account[:provider], uid: account[:uid])
    end

    def find_user_id_by_account(account)
      find_by(provider: account[:provider], uid: account[:uid])&.dao_user_id
    end
  end
end
