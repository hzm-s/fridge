# typed: false
require 'rails_helper'

RSpec.describe 'sign_in' do
  let(:other_user_auth_hash) { mock_auth_hash }

  before do
    sign_up_with_auth_auth(other_user_auth_hash)
  end

  context 'when signed up' do
    let(:auth_hash) { mock_auth_hash }

    before do
      @user = sign_up_with_auth_auth(auth_hash)
      set_auth_hash(auth_hash)
    end

    it 'ログイン状態にすること' do
      get oauth_callback_path(provider: auth_hash['provider'])
      follow_redirect!

      expect(session[:user_id]).to eq @user.id
    end
  end
end
