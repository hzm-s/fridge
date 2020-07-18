require 'omniauth_test_helper'
require 'securerandom'

module OauthSupport
  module Common
    def set_auth_hash(auth_hash)
      OmniAuth.config.add_mock(auth_hash['provider'].to_sym, auth_hash)
    end
  end
end

RSpec.configure do |c|
  c.include OauthSupport::Common
end

OmniAuth.config.test_mode = true
OmniAuthTestHelper.register_generator do |g|
  g.for(:provider) { 'google_oauth2' }
  g.for(:uid) { SecureRandom.base64(14) }
  g.for(:name) { |h| "ユーザー #{h[:uid][0, 5]}"  }
  g.for(:email) { |h| "#{h[:uid]}@gmail.com" }
end
