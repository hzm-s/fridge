# typed: ignore
module UserQuery
  class User < SimpleDelegator
    def user_account_id
      id
    end
  end

  class << self
    def call(user_account_id)
      r = App::UserAccount.eager_load(:person).find(user_account_id)
      User.new(r)
    end
  end
end
