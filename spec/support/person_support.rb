# typed: ignore
require_relative '../domain_support/person_domain_support'

module PersonSupport
  module Common
    include PersonDomainSupport

    def register_person(attrs = default_person_registration_attrs)
      RegisterPersonUsecase.perform(attrs[:name], attrs[:email], attrs[:oauth_info])
        .yield_self { |person_id| PersonRepository::AR.find_by_id(person_id) }
    end

    private

    def default_person_registration_attrs
      auth_hash = mock_auth_hash
      {
        name: auth_hash['info']['name'],
        email: auth_hash['info']['email'],
        oauth_info: {
          provider: auth_hash['provider'],
          uid: auth_hash['uid'],
          image: 'https://ima.ge/123'
        }
      }
    end
  end

  module Requests
    def sign_up_with_auth_hash(auth_hash = mock_auth_hash)
      name = auth_hash['info']['name']
      email = auth_hash['info']['email']
      oauth_account = { provider: auth_hash['provider'], uid: auth_hash['uid'] }
      RegisterUserUsecase.perform(name, email, oauth_account)
        .yield_self { |user_id| Dao::User.eager_load(:oauth_account).find(user_id.to_s) }
    end
    alias_method :sign_up, :sign_up_with_auth_hash

    def sign_in(user)
      auth_hash = auth_hash_from_user(user)
      set_auth_hash(auth_hash)
      get oauth_callback_path(provider: auth_hash['provider'])
    end
  end
end

RSpec.configure do |c|
  c.include PersonSupport::Common
  c.include PersonSupport::Requests, type: :request
end
