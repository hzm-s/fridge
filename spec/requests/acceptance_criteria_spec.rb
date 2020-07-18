# typed: false
require 'rails_helper'

RSpec.describe 'acceptance_criteria' do
  let!(:product) { create_product }
  let!(:pbi) { add_pbi(product.id) }

  describe '#create' do
    context 'given valid params' do
      it do
        params = { form: { content: 'ukeire_kijyun' } }
        post product_backlog_item_acceptance_criteria_path(product_backlog_item_id: pbi.id, format: :js), params: params
        follow_redirect!
        expect(response.body).to include 'ukeire_kijyun'
      end
    end

    context 'given invalid params' do
      it do
        params = { form: { content: '' } }
        post product_backlog_item_acceptance_criteria_path(product_backlog_item_id: pbi.id, format: :js), params: params
        expect(response.body).to include I18n.t('errors.messages.blank')
      end
    end
  end

  describe '#destroy' do
    it do
      add_acceptance_criteria(pbi, %w(ukeire_kijyun))

      delete product_backlog_item_acceptance_criterion_path(product_backlog_item_id: pbi.id, no: 1)
      follow_redirect!

      expect(response.body).to_not include 'ukeire_kijyun'
    end
  end
end
