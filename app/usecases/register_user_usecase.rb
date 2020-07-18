# typed: ignore
require 'sorbet-runtime'

class RegisterUserUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(UserRepository::AR, User::UserRepository)
  end

  sig {params(name: String, email: String, oauth_account: T::Hash[Symbol, String]).returns(T::Hash[Symbol, T.any(T::Boolean, T.nilable(String))])}
  def perform(name, email, oauth_account)
    return { is_registered: false, user_id: nil } if App::OauthAccount.exists?(oauth_account)

    user = User::User.create(name, email)

    transaction do
      @repository.add(user)
      App::OauthAccount.create_with_user(user.id, oauth_account)
    end

    { is_registered: true, user_id: user.id }
  end
end
