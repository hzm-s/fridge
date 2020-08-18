# typed: strict
require 'sorbet-runtime'

class RegisterOrFindPersonUsecase < UsecaseBase
  extend T::Sig

  Result = T.type_alias {T::Hash[Symbol, T.any(T::Boolean, T.nilable(Person::Id))]}

  sig {params(name: String, email: String, oauth_info: RegisterPersonUsecase::OauthInfo).returns(Result)}
  def perform(name, email, oauth_info)
    person_id =
      App::UserAccount.find_person_id_by_oauth_account(
        provider: oauth_info[:provider],
        uid: oauth_info[:uid]
      )
    return found(Person::Id.from_string(person_id)) if person_id

    registered(::RegisterPersonUsecase.perform(name, email, oauth_info))
  end

  private

  sig {params(person_id: Person::Id).returns(Result)}
  def found(person_id)
    { is_register: false, person_id: person_id }
  end

  sig {params(person_id: Person::Id).returns(Result)}
  def registered(person_id)
    { is_register: true, person_id: person_id }
  end
end
