# typed: false
require 'rails_helper'

RSpec.describe 'acceptance_criteria' do
  let!(:user_account) { sign_up }
  let!(:product) { create_product(person: user_account.person_id) }
  let!(:issue) { plan_issue(product.id) }

  before do
    sign_in(user_account)
  end

  describe 'create' do
    context 'given valid params' do
      it do
        post issue_acceptance_criteria_path(issue_id: issue.id, format: :js), params: { form: { content: 'ukeire' } }
        follow_redirect!

        expect(response.body).to include 'ukeire'
      end
    end

    context 'given invalid params' do
      it do
        post issue_acceptance_criteria_path(issue_id: issue.id, format: :js), params: { form: { content: '' } }
        expect(response.body).to include I18n.t('errors.messages.blank')
      end
    end
  end

  describe 'update' do
    before do
      append_acceptance_criteria(issue, %w(Ukeire1 Ukeire2 Ukeire3))
    end

    context 'given invalid params' do
      it do
        patch issue_acceptance_criterion_path(issue_id: issue.id, number: 2, format: :js), params: { form: { content: '' } }

        expect(response.body).to include(I18n.t('errors.messages.blank'))
      end
    end
  end

  describe 'destroy' do
    before do
      append_acceptance_criteria(issue, %w(ac_head ukeire_kijyun ac_tail))
    end

    it do
      delete issue_acceptance_criterion_path(issue_id: issue.id, number: 2)
      follow_redirect!

      expect(response.body).to_not include 'ukeire_kijyun'
    end
  end
end
