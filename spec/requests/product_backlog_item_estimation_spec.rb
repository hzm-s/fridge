# typed: false
require 'rails_helper'

RSpec.describe 'product_backlog_estimation' do
  let!(:user_account) { sign_up }
  let!(:product) { create_product(person_id: user_account.person_id) }
  let!(:pbi) { add_pbi(product.id) }

  describe '#update' do
    it do
      put product_backlog_item_estimation_path(pbi.id, format: :js), params: { form: { point: '8' } }

      updated = ProductBacklogItemRepository::AR.find_by_id(pbi.id)
      expect(updated.size.to_i).to eq 8
    end

    it do
      put product_backlog_item_estimation_path(pbi.id, format: :js), params: { form: { point: '?' } }

      updated = ProductBacklogItemRepository::AR.find_by_id(pbi.id)
      expect(updated.size.to_i).to eq nil 
    end
  end
end
