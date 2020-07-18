require 'rails_helper'

RSpec.describe RegisterUserUsecase do
  let(:oauth_account) { { provider: 'google_oauth2', uid: '123456789' } }
  let(:name) { 'User Name' }
  let(:email) { 'user@example.com' }

  it do
    user_id = described_class.perform(name, email, oauth_account)
    user = UserRepository::AR.find_by_id(user_id)
    account = App::OauthAccount.find_by_user_id(user_id)

    aggregate_failures do
      expect(user.name).to eq name
      expect(user.avatar.initials).to eq 'US'
      expect(user.avatar.bg).to_not be_nil
      expect(user.avatar.fg).to_not be_nil

      expect(account.provider).to eq oauth_account[:provider]
      expect(account.uid).to eq oauth_account[:uid]
    end
  end

  it '同じメールアドレスで複数登録できないこと' do
    described_class.perform(name, email, oauth_account)

    expect { described_class.perform(name, email, oauth_account) }
      .to change { Dao::User.count }.by(0)
      .and change { App::OauthAccount.count }.by(0)
  end
end
