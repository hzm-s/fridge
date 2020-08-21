# typed: true
require 'omniauth_test_helper'
require 'securerandom'

module OauthSupport

  def set_auth_hash(auth_hash)
    OmniAuth.config.add_mock(auth_hash['provider'].to_sym, auth_hash)
  end

  def auth_hash_from_user(user_account)
    {
      'provider' => user_account.provider,
      'uid' => user_account.uid,
      'info' => {
        'name' => user_account.person.name,
        'email' => user_account.person.email,
      }
    }
  end
end

RSpec.configure do |c|
  c.include OmniAuthTestHelper
  c.include OauthSupport
end

OmniAuth.config.test_mode = true
OmniAuthTestHelper.register_generator do |g|
  g.for(:provider) { 'google_oauth2' }
  g.for(:uid) { SecureRandom.base64(14) }
  g.for(:name) { |h| "ユーザー #{h[:uid][0, 5]}"  }
  g.for(:email) { |h| "#{h[:uid]}@gmail.com" }
end
