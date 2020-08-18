# typed: ignore
module UserQuery
  class User < Struct.new(:user_account_id, :person_id, :name, :image)
    def self.build(user_account)
      new(
        user_account.id,
        user_account.person.id,
        user_account.person.name,
        user_account.image
      )
    end
  end

  class << self
    def call(user_account_id)
      r = App::UserAccount.eager_load(:person).find(user_account_id)
      User.build(r)
    end
  end
end
