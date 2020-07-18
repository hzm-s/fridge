# typed: ignore
require 'rails_helper'

RSpec.describe RegisterUserUsecase do
  let(:oauth_account) { { provider: 'google_oauth2', uid: '123456789' } }
  let(:name) { 'User Name' }
  let(:email) { 'user@example.com' }

  it do
    user_id = described_class.perform(name, email, oauth_account)

    user = UserRepository::AR.find_by_id(user_id)
    account = App::OauthAccount.find_by(oauth_account)

    aggregate_failures do
      expect(user.name).to eq name
      expect(user.avatar.initials).to eq 'US'
      expect(user.avatar.bg).to_not be_nil
      expect(user.avatar.fg).to_not be_nil

      expect(account.dao_user_id).to eq user.id
      expect(account.provider).to eq oauth_account[:provider]
      expect(account.uid).to eq oauth_account[:uid]
    end
  end

  context '同じメールアドレスを持つユーザーが登録済みの場合' do
    it '登録しないこと' do
      described_class.perform(name, email, oauth_account)

      expect { described_class.perform('Other User', email, { provider: 'google_oauth2', uid: 'other_uid' }) }
        .to raise_error(ActiveRecord::RecordNotUnique)
        .and change { Dao::User.count }.by(0)
        .and change { App::OauthAccount.count }.by(0)
    end
  end
end
