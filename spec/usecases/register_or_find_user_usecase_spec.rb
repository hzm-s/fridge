# typed: false
require 'rails_helper'

RSpec.describe RegisterOrFindUserUsecase do
  let(:name) { 'User Name' }
  let(:email) { 'user@example.com' }
  let(:oauth_account) { { provider: 'google_oauth2', uid: '123' } }

  context 'when NOT registered' do
    it do
      result = described_class.perform(name, email, oauth_account)
      expect(result[:is_register]).to be true
      expect(result[:user_id]).to_not be_nil
    end
  end

  context 'when registered' do
    before do
      @user = register_user(name, email, oauth_account)
    end

    it do
      result = described_class.perform(name, email, oauth_account)
      expect(result[:is_register]).to be false
      expect(result[:user_id]).to eq @user.id
    end
  end
end
