# typed: ignore
require 'rails_helper'

describe RegisterPersonUsecase do
  let(:oauth_info) { { provider: 'google_oauth2', uid: '123456789' } }
  let(:name) { 'User Name' }
  let(:email) { 'user@example.com' }

  it do
    user_account_id = described_class.perform(name, email, oauth_info)

    user_account = App::UserAccount.find(user_account_id)
    person = PersonRepository::AR.find_by_id(Person::Id.from_string(user_account.dao_person_id))

    aggregate_failures do
      expect(person.name).to eq name
      expect(person.email).to eq email

      expect(user_account.dao_person_id).to eq person.id.to_s
      expect(user_account.provider).to eq oauth_info[:provider]
      expect(user_account.uid).to eq oauth_info[:uid]

      expect(user_account.initials).to_not be_nil
      expect(user_account.fgcolor).to_not be_nil
      expect(user_account.bgcolor).to_not be_nil
    end
  end

  context '同じメールアドレスを持つユーザーが登録済みの場合' do
    it '登録しないこと' do
      described_class.perform(name, email, oauth_info)

      expect {
        described_class.perform('Other User', email, { provider: 'google_oauth2', uid: 'other_uid' })
      }
        .to raise_error(Person::EmailNotUnique)
        .and change { Dao::Person.count }.by(0)
        .and change { App::UserAccount.count }.by(0)
    end
  end
end
