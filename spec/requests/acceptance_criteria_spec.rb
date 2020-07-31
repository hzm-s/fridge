# typed: false
require 'rails_helper'

RSpec.describe 'acceptance_criteria' do
  let!(:user) { sign_up }
  let!(:product) { create_product(user_id: User::Id.from_string(user.id)) }
  let!(:pbi) { add_pbi(product.id) }

  before do
    sign_in(user)
  end

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
      add_acceptance_criteria(pbi, %w(ac_head ukeire_kijyun ac_tail))

      target = Dao::AcceptanceCriterion.find_by(content: 'ukeire_kijyun')
      delete acceptance_criterion_path(target.id)
      follow_redirect!

      expect(response.body).to_not include 'ukeire_kijyun'
    end
  end
end
