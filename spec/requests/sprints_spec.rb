# typed: false
require 'rails_helper'

RSpec.describe 'sprints' do
  let!(:user_account) { sign_up }
  let!(:product) { create_product(person: user_account.person_id) }

  before do
    sign_in(user_account)
  end

  describe 'create' do
    it do
      post sprints_path(product_id: product.id.to_s)
      follow_redirect!

      sprint = SprintRepository::AR.current(product.id)
      expect(response.body).to include "test-sprint-backlog-#{sprint.id}"

      expect { post sprints_path(product_id: product.id.to_s) }
        .to change { Dao::Sprint.count }.by(0)
    end
  end
end
