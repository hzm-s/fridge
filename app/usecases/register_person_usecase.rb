# typed: strict
require 'sorbet-runtime'

class RegisterPersonUsecase < UsecaseBase
  extend T::Sig

  OauthAccount = T.type_alias {T::Hash[Symbol, String]}

  sig {void}
  def initialize
    @repository = T.let(PersonRepository::AR, Person::PersonRepository)
  end

  sig {params(name: String, email: String, oauth_account: OauthAccount).returns(String)}
  def perform(name, email, oauth_account)
    person = Person::Person.create(name, email)

    user_account = App::UserAccount.create_for_person(
      person.id,
      provider: oauth_account[:provider],
      uid: oauth_account[:uid]
    )
    user_account.initialize_profile(email)

    transaction do
      @repository.add(person)
      user_account.save!
    end

    user_account.id
  end
end
