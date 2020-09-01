# typed: false
require 'rails_helper'

RSpec.describe 'teams' do
  let(:user_account) { sign_up }

  before do
    sign_in(user_account)
  end

  describe '#create' do
    it do
      post teams_path, params: { form: { name: 'KAIHATSU GUMI', role: 'developer' } }
      follow_redirect!

      expect(response.body).to include 'KAIHATSU GUMI'
    end

    it do
      post teams_path, params: { form: { name: '', role: 'developer' } }
      expect(response.body).to include I18n.t('errors.messages.blank')
    end
  end
end
