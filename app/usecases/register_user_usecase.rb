# typed: ignore
require 'sorbet-runtime'

class RegisterUserUsecase < UsecaseBase
  extend T::Sig

  Result = T.type_alias {T::Hash[Symbol, T.any(T::Boolean, T.nilable(String))]}

  sig {void}
  def initialize
    @repository = T.let(UserRepository::AR, User::UserRepository)
  end

  sig {params(name: String, email: String, oauth_account: T::Hash[Symbol, String]).returns(Result)}
  def perform(name, email, oauth_account)
    user_id = App::OauthAccount.find_user_by_account(oauth_account)
    return { is_registered: false, user_id: user_id } if user_id

    user = register_user(name, email, oauth_account)
    { is_registered: true, user_id: user.id }
  end

  private

  def register_user(name, email, oauth_account)
    user = User::User.create(name, email)

    transaction do
      @repository.add(user)
      App::OauthAccount.create_with_user(user.id, oauth_account)
    end

    user
  end
end
