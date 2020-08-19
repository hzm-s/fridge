# typed: strict
require 'sorbet-runtime'

class RegisterOrFindPersonUsecase < UsecaseBase
  extend T::Sig

  Result = T.type_alias {T::Hash[Symbol, T.any(T::Boolean, T.nilable(String))]}

  sig {params(name: String, email: String, oauth_info: RegisterPersonUsecase::OauthInfo).returns(Result)}
  def perform(name, email, oauth_info)
    user_account_id =
      App::UserAccount.find_id_by_oauth_account(
        provider: oauth_info[:provider],
        uid: oauth_info[:uid]
      )
    return found(user_account_id) if user_account_id

    registered(::RegisterPersonUsecase.perform(name, email, oauth_info))
  end

  private

  sig {params(user_account_id: String).returns(Result)}
  def found(user_account_id)
    { is_register: false, user_account_id: user_account_id }
  end

  sig {params(user_account_id: String).returns(Result)}
  def registered(user_account_id)
    { is_register: true, user_account_id: user_account_id }
  end
end
