# typed: false
require 'rails_helper'

RSpec.describe 'teams' do
  let(:user_account) { sign_up }

  before do
    sign_in(user_account)
  end

  let!(:product) { create_product(person: user_account.person_id) }

  describe 'create' do
    it do
      post teams_path, params: { form: { product_id: product.id.to_s, name: 'KAIHATSU GUMI' } }
      follow_redirect!

      expect(response.body).to include team_path(Dao::Team.last.id)
    end

    it do
      post teams_path, params: { form: { product_id: product.id, name: '' } }
      expect(response.body).to include I18n.t('errors.messages.blank')
    end
  end

  describe 'show' do
    it do
      get team_path(resolve_team(product.id).id.to_s)

      expect(response.body).to include user_account.person.name.to_s
    end
  end
end
