# typed: strict
require 'sorbet-runtime'

class RegisterPersonUsecase < UsecaseBase
  extend T::Sig

  OauthInfo = T.type_alias {T::Hash[Symbol, T.nilable(String)]}

  sig {void}
  def initialize
    @repository = T.let(PersonRepository::AR, Person::PersonRepository)
  end

  sig {params(name: String, email: String, oauth_info: OauthInfo).returns(String)}
  def perform(name, email, oauth_info)
    person = Person::Person.create(name, email)

    transaction do
      @repository.add(person)
      App::UserAccount.create_for_person(person.id, oauth_info).id
    end
  end
end
