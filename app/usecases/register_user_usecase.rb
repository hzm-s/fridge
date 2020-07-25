# typed: true
require 'sorbet-runtime'

class RegisterUserUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(UserRepository::AR, User::UserRepository)
  end

  sig {params(name: String, email: String, oauth_account: T::Hash[Symbol, String]).returns(User::Id)}
  def perform(name, email, oauth_account)
    user = User::User.create(name, email)

    transaction do
      @repository.add(user)
      App::OauthAccount.create_for_user(user.id, oauth_account)
      App::Avatar.create_for_user(user.id)
    end

    user.id
  end
end
