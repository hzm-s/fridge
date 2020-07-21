# typed: ignore
module UserSupport
  module Common
    def register_user(attrs = default_user_registration_attrs)
      RegisterUserUsecase.perform(attrs[:name], attrs[:email], attrs[:oauth_account])
        .yield_self { |user_id| UserRepository::AR.find_by_id(user_id) }
    end

    private

    def default_user_registration_attrs
      auth_hash = mock_auth_hash
      {
        name: auth_hash['info']['name'],
        email: auth_hash['info']['email'],
        oauth_account: {
          provider: auth_hash['provider'],
          uid: auth_hash['uid']
        }
      }
    end
  end

  module Requests
    def sign_up_with_auth_auth(auth_hash = mock_auth_hash)
      name = auth_hash['info']['name']
      email = auth_hash['info']['email']
      oauth_account = { provider: auth_hash['provider'], uid: auth_hash['uid'] }
      RegisterUserUsecase.perform(name, email, oauth_account)
        .yield_self { |user_id| Dao::User.eager_load(:oauth_account).find(user_id) }
    end
    alias_method :sign_up, :sign_up_with_auth_auth

    def sign_in(user)
      auth_hash = auth_hash_from_user(user)
      set_auth_hash(auth_hash)
      get oauth_callback_path(provider: auth_hash['provider'])
    end
  end
end

RSpec.configure do |c|
  c.include UserSupport::Common
  c.include UserSupport::Requests, type: :request
end
