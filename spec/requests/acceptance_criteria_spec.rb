# typed: false
require 'rails_helper'

RSpec.describe 'acceptance_criteria' do
  let!(:user_account) { sign_up }
  let!(:product) { create_product(person: user_account.person_id) }
  let!(:issue) { add_issue(product.id) }

  before do
    sign_in(user_account)
  end

  describe '#create' do
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

  describe '#destroy' do
    it do
      append_acceptance_criteria(issue, %w(ac_head ukeire_kijyun ac_tail))

      target = Dao::AcceptanceCriterion.find_by(content: 'ukeire_kijyun')
      delete acceptance_criterion_path(target.id)
      follow_redirect!

      expect(response.body).to_not include 'ukeire_kijyun'
    end
  end
end
