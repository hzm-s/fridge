# typed: false
require 'rails_helper'

describe 'sprints' do
  let!(:user_account) { sign_up }
  let!(:product) { create_product(person: user_account.person_id) }

  describe 'create' do
    before { sign_in(user_account) }

    it do
      post sprints_path(product_id: product.id.to_s)
      follow_redirect!

      sprint = SprintRepository::AR.current(product.id)
      expect(response.body).to include "test-sprint-backlog-#{sprint.id}"

      expect { post sprints_path(product_id: product.id.to_s) }
        .to change { Dao::Sprint.count }.by(0)
    end
  end

  it_behaves_like('sign_in_guard') { let(:r) { post sprints_path(product_id: 1) } }
end
