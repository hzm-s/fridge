# typed: false
require 'rails_helper'

RSpec.describe RegisterOrFindPersonUsecase do
  let(:name) { 'User Name' }
  let(:email) { 'user@example.com' }
  let(:oauth_info) { { provider: 'google_oauth2', uid: '123', image: 'https://ima.ge/123' } }

  context 'when NOT registered' do
    it do
      result = described_class.perform(name, email, oauth_info)
      expect(result[:is_register]).to be true
      expect(result[:user_account_id]).to_not be_nil
    end
  end

  context 'when registered' do
    before do
      @user = register_person(name: name, email: email, oauth_info: oauth_info)
    end

    it do
      result = described_class.perform(name, email, oauth_info)
      expect(result[:is_register]).to be false
      expect(result[:user_account_id]).to eq @user.user_account_id
    end
  end
end