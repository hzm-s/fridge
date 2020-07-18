require 'rails_helper'

RSpec.describe RegisterUserUsecase do
  let(:oauth_account) { { provider: 'google_oauth2', uid: '123456789' } }
  let(:name) { 'User Name' }
  let(:email) { 'user@example.com' }

  it do
    result = described_class.perform(name, email, oauth_account)
    user_id = result[:user_id]
    user = UserRepository::AR.find_by_id(user_id)
    account = App::OauthAccount.find_by_user_id(user_id)

    aggregate_failures do
      expect(result[:is_registered]).to be true

      expect(user.name).to eq name
      expect(user.avatar.initials).to eq 'US'
      expect(user.avatar.bg).to_not be_nil
      expect(user.avatar.fg).to_not be_nil

      expect(account.provider).to eq oauth_account[:provider]
      expect(account.uid).to eq oauth_account[:uid]
    end
  end

  context '同じメールアドレスを持つユーザーが登録済みの場合' do
    it '登録できないこと' do
      described_class.perform(name, email, oauth_account)

      expect { described_class.perform('Other User', email, { provider: 'google_oauth2', uid: 'other_uid' }) }
        .to change { Dao::User.count }.by(0)
        .and change { App::OauthAccount.count }.by(0)
    end
  end

  context '同じOauthアカウントを持つユーザーが登録済みの場合' do
    before do
      described_class.perform(name, email, oauth_account)
    end

    it '登録済であることを返すこと' do
      result = described_class.perform(name, email, oauth_account)

      aggregate_failures do
        expect(result[:is_registered]).to be false
        expect(result[:user_id]).to be nil
      end
    end

    it '登録しないこと' do
      expect { described_class.perform(name, email, oauth_account) }
        .to change { Dao::User.count }.by(0)
        .and change { App::OauthAccount.count }.by(0)
    end
  end
end
