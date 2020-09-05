# typed: ignore
module UserQuery
  class << self
    def call(user_account_id)
      r = App::UserAccount.eager_load(:person, :profile).find(user_account_id)
      User.build(r)
    end
  end

  class User < Struct.new(:user_account_id, :person_id, :name, :avatar)
    def self.build(user_account)
      new(
        user_account.id,
        Person::Id.from_string(user_account.person.id),
        user_account.person.name,
        {
          initials: user_account.initials,
          fgcolor: user_account.fgcolor,
          bgcolor: user_account.bgcolor,
        }
      )
    end
  end
end
