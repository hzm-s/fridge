# typed: strict
require 'sorbet-runtime'

class RegisterOrFindUserUsecase < UsecaseBase
  extend T::Sig

  Result = T.type_alias {T::Hash[Symbol, T.any(T::Boolean, T.nilable(User::Id))]}

  sig {params(name: String, email: String, oauth_account: T::Hash[Symbol, String]).returns(Result)}
  def perform(name, email, oauth_account)
    user_id = App::OauthAccount.find_user_id_by_account(oauth_account)
    return found(User::Id.from_string(user_id)) if user_id

    registered(::RegisterUserUsecase.perform(name, email, oauth_account))
  end

  private

  sig {params(user_id: User::Id).returns(Result)}
  def found(user_id)
    { is_register: false, user_id: user_id }
  end

  sig {params(user_id: User::Id).returns(Result)}
  def registered(user_id)
    { is_register: true, user_id: user_id }
  end
end
