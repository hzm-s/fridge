# typed: false
require 'rails_helper'

RSpec.describe 'plans' do
  let!(:user_account) { sign_up }
  let!(:product) { create_product(owner: user_account.person_id) }

  before do
    sign_in(user_account)
  end

  describe '#update' do
    context 'when sort not scoped issues' do
      it do
        expect(SortIssuesUsecase).to receive(:perform).with(product.id, Issue::Id.from_string('123'), 1)
        params = { issue_id: 123, to_index: 1 }
        patch product_plan_path(product_id: product.id.to_s, format: :json), params: params
      end
    end
  end
end
