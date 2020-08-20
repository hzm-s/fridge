# typed: false
require 'rails_helper'

RSpec.describe 'sign_up' do
  context 'when NOT signed up' do
    let(:auth_hash) { mock_auth_hash }

    before do
      set_auth_hash(auth_hash)
    end

    it 'ユーザーアカウントを登録すること' do
      expect { get oauth_callback_path(provider: auth_hash['provider']) }
        .to change { Dao::Person.count }.by(1)
        .and change { App::UserAccount.count }.by(1)
    end

    it 'ユーザーアカウント登録完了メッセージを表示すること' do
      get oauth_callback_path(provider: auth_hash['provider'])
      follow_redirect!

      expect(response.body).to include I18n.t('feedbacks.signed_up')
    end
  end

  context 'when signed up' do
    let(:auth_hash) { mock_auth_hash }

    before do
      sign_up_with_auth_hash(auth_hash)
      set_auth_hash(auth_hash)
    end

    it 'ユーザーアカウントを登録しないこと' do
      expect { get oauth_callback_path(provider: auth_hash['provider']) }
        .to change { Dao::Person.count }.by(0)
        .and change { App::UserAccount.count }.by(0)
    end

    it 'ユーザーアカウント登録完了メッセージを表示しないこと' do
      get oauth_callback_path(provider: auth_hash['provider'])
      follow_redirect!

      expect(response.body).to_not include I18n.t('feedbacks.signed_up')
    end
  end

  context 'when signed in' do
    let(:user_account) { sign_up }

    before do
      sign_in(user_account)
    end

    it do
      get oauth_callback_path(provider: user_account.provider)
      follow_redirect!

      expect(response.body).to include I18n.t('feedbacks.already_signed_in')
    end
  end
end
