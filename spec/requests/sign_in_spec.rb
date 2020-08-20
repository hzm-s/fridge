# typed: false
require 'rails_helper'

RSpec.describe 'sign_in' do
  let(:user_auth_hash) { mock_auth_hash }
  let(:other_user_auth_hash) { mock_auth_hash }

  before do
    sign_up_with_auth_hash(other_user_auth_hash)
  end

  context 'when signed up' do
    before do
      @user_account = sign_up_with_auth_hash(user_auth_hash)
      set_auth_hash(user_auth_hash)
    end

    it 'ログイン状態にすること' do
      get oauth_callback_path(provider: user_auth_hash['provider'])

      expect(session[:user_account_id]).to eq @user_account.id
    end

    context 'when signed in' do
      before do
        sign_in(@user_account)
      end

      it do
        get oauth_callback_path(provider: user_auth_hash['provider'])
        follow_redirect!

        expect(response.body).to include I18n.t('feedbacks.already_signed_in')
      end
    end
  end

  context 'when NOT signed up' do
    it 'ユーザー登録すること' do
      expect { get oauth_callback_path(provider: user_auth_hash['provider']) }
        .to change { Dao::Person.count }.by(1)
        .and change { App::UserAccount.count }.by(1)
    end
  end
end
