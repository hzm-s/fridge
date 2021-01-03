# typed: false
require 'rails_helper'

RSpec.describe 'teams' do
  let(:user_account) { sign_up }

  before do
    sign_in(user_account)
  end

  let!(:product) { create_product(person: user_account.person_id) }

  describe 'show' do
    it do
      get team_path(resolve_team(product.id).id.to_s)

      expect(response.body).to include user_account.person.name.to_s
    end
  end
end
