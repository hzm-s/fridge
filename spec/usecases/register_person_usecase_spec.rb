# typed: ignore
require 'rails_helper'

RSpec.describe RegisterPersonUsecase do
  let(:oauth_info) { { provider: 'google_oauth2', uid: '123456789', image: 'https://ima.ge/123' } }
  let(:name) { 'User Name' }
  let(:email) { 'user@example.com' }

  it do
    person_id = described_class.perform(name, email, oauth_info)

    person = PersonRepository::AR.find_by_id(person_id)
    account = App::UserAccount.find_by(provider: oauth_info[:provider], uid: oauth_info[:uid])

    aggregate_failures do
      expect(person.name).to eq name
      expect(person.email).to eq email

      expect(account.dao_person_id).to eq person.id.to_s
      expect(account.provider).to eq oauth_info[:provider]
      expect(account.uid).to eq oauth_info[:uid]
      expect(account.image).to eq oauth_info[:image]
    end
  end

  context '同じメールアドレスを持つユーザーが登録済みの場合' do
    it '登録しないこと' do
      described_class.perform(name, email, oauth_info)

      expect {
        described_class.perform('Other User', email, { provider: 'google_oauth2', uid: 'other_uid', image: 'other.image' })
      }
        .to raise_error(Person::EmailNotUnique)
        .and change { Dao::Person.count }.by(0)
        .and change { App::UserAccount.count }.by(0)
    end
  end
end
