# typed: false
require 'rails_helper'

RSpec.describe 'release_items' do
  let(:user_account) { sign_up }
  let(:product) { create_product(owner: user_account.person_id) }
  let(:release) { add_release(product.id) }
  let(:issue) { add_issue(product.id, 'ABC') }

  before do
    sign_in(user_account)
  end

  describe 'create' do
    post release_items_path(release_id: release.id.to_s, format: :json), params: { item: issue.id }

    get product_backlog_path(product.id)

    expect(response.body).to include issue.description.to_s
  end
end
