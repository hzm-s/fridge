# typed: ignore

module UserAccountSupport
  module Requests
    def sign_up_with_auth_hash(auth_hash = mock_auth_hash)
      name = auth_hash['info']['name']
      email = auth_hash['info']['email']
      oauth_info = {
        provider: auth_hash['provider'],
        uid: auth_hash['uid'],
        image: auth_hash['info']['image']
      }
      RegisterPersonUsecase.perform(name, email, oauth_info)
        .yield_self { |user_account_id| App::UserAccount.eager_load(:person).find(user_account_id) }
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
