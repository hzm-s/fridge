# typed: false
require 'rails_helper'

RSpec.describe 'product_backlogs' do
  let!(:user_account) { sign_up }

  context 'when PO' do
    let!(:product) { create_product(person: user_account.person_id, roles: team_roles(:po)) }
    before { sign_in(user_account) }

    it do
      get product_backlog_path(product_id: product.id)
      expect(response.body).to include 'test-change-issue-priority'
    end
  end

  context 'when Dev' do
    let!(:product) { create_product(person: user_account.person_id, roles: team_roles(:dev)) }
    before { sign_in(user_account) }

    it do
      get product_backlog_path(product_id: product.id)
      expect(response.body).to_not include 'test-change-issue-priority'
    end
  end
end
