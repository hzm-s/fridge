# typed: ignore

module UserAccountSupport
  class Wrapper < SimpleDelegator
    def self.load(user_account_id)
      new(App::UserAccount.eager_load(:person).find(user_account_id))
    end

    def person_id
      Person::Id.from_string(person.id)
    end
  end

  module Requests
    def sign_up_with_auth_hash(auth_hash = mock_auth_hash)
      name = auth_hash['info']['name']
      email = auth_hash['info']['email']
      oauth_account = {
        provider: auth_hash['provider'],
        uid: auth_hash['uid'],
      }
      RegisterPersonUsecase.perform(name, email, oauth_account)
        .yield_self { |user_account_id| Wrapper.load(user_account_id) }
    end
    alias_method :sign_up, :sign_up_with_auth_hash

    def sign_in(user_account)
      auth_hash = auth_hash_from_user(user_account)
      set_auth_hash(auth_hash)
      get oauth_callback_path(provider: auth_hash['provider'])
    end
  end
end

RSpec.configure do |c|
  c.include UserAccountSupport::Requests, type: :request
end
