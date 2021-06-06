# typed: false
require 'rails_helper'

RSpec.describe 'sprint_backlogs' do
  let!(:user_account) { sign_up }
  let!(:product) { create_product(person: user_account.person_id) }

  before do
    sign_in(user_account)
  end

  context 'current sprint is NOT exists' do
    it do
      get sprint_backlog_path(product.id)
      follow_redirect!
      expect(response.body).to include 'test-start-sprint'
    end
  end

  context 'current sprint is exists' do
    let!(:sprint) { start_sprint(product.id) }

    it do
      get sprint_backlog_path(product.id)
      expect(response.body).to include "test-sprint-backlog-#{sprint.id}"
    end
  end

  context 'when PO' do
  end

  context 'when Dev' do
  end
end
