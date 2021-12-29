# typed: false
require 'rails_helper'

describe RegisterOrFindPersonUsecase do
  let(:name) { 'User Name' }
  let(:email) { 'user@example.com' }
  let(:oauth_account) { { provider: 'google_oauth2', uid: '123' } }

  context 'when NOT registered' do
    it do
      result = described_class.perform(name, email, oauth_account)
      expect(result[:is_register]).to be true
      expect(result[:user_account_id]).to_not be_nil
    end
  end

  context 'when registered' do
    before do
      person = sign_up_as_person(name: name, email: email, oauth_account: oauth_account)
      @user_account = App::UserAccount.find_by(dao_person_id: person.id.to_s)
    end

    it do
      result = described_class.perform(name, email, oauth_account)
      expect(result[:is_register]).to be false
      expect(result[:user_account_id]).to eq @user_account.id
    end
  end
end
