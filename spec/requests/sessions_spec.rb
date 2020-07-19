# typed: false
require 'rails_helper'

RSpec.describe 'sessions' do
  let(:user) { sign_up }

  context 'when NOT signed in' do
    it do
      get sign_in_path
      expect(response.body).to include '/auth/google_oauth2'
    end
  end

  context 'when signed in' do
    before do
      sign_in(user)
    end

    it do
      get sign_in_path
      follow_redirect!

      expect(response.body).to include I18n.t('feedbacks.already_signed_in')
    end
  end
end
