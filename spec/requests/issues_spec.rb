# typed: false
require 'rails_helper'

RSpec.describe 'issues' do
  let!(:user_account) { sign_up }
  let!(:product) { create_product(owner: user_account.person_id) }

  before do
    sign_in(user_account)
  end

  describe 'create' do
    context 'given valid params' do
      it do
        params = { form: { type: 'feature', description: 'ABC' } }
        post product_issues_path(product_id: product.id.to_s, format: :js), params: params
        get product_backlog_path(product_id: product.id.to_s)

        expect(response.body).to include 'ABC'
      end
    end

    context 'given invalid params' do
      it do
        post product_issues_path(product_id: product.id.to_s, format: :js), params: { form: { type: 'feature', description: '' } }

        expect(response.body).to include(I18n.t('errors.messages.blank'))
      end
    end
  end

  describe 'edit' do
    it do
      issue = add_issue(product.id, 'XYZ')
      add_acceptance_criteria(issue, %w(AC_123))

      get edit_issue_path(issue.id.to_s)

      aggregate_failures do
        expect(response.body).to include('XYZ')
        expect(response.body).to include('AC_123')
      end
    end
  end

  describe 'update' do
    let!(:issue) { add_issue(product.id, 'ABC') }

    context '入力内容が正しい場合' do
      it do
        patch issue_path(issue.id, format: :js), params: { form: { type: 'task', description: 'XYZ' } }
        follow_redirect!

        expect(response.body).to include('XYZ')
      end
    end

    context '入力内容が正しくない場合' do
      it do
        patch issue_path(issue.id, format: :js), params: { form: { type: 'task', description: '' } }
        expect(response.body).to include(I18n.t('errors.messages.blank'))
      end
    end
  end

  describe 'destroy' do
    it do
      issue = add_issue(product.id, 'YOHKYU')

      delete issue_path(issue.id)
      follow_redirect!

      expect(response.body).to_not include 'YOHKYU'
    end
  end
end
