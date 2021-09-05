# typed: false
require 'rails_helper'

RSpec.describe 'teams' do
  let(:user_account) { sign_up }
  let!(:product) { create_product(person: user_account.person_id) }

  describe 'show' do
    before { sign_in(user_account) }

    it do
      get team_path(resolve_team(product.id).id.to_s)

      expect(response.body).to include user_account.person.name.to_s
    end
  end

  it_behaves_like('sign_in_guard') { let(:r) { get team_path(1) } }
end
