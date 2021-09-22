# typed: false
require 'rails_helper'

RSpec.describe 'issues' do
  let!(:user_account) { sign_up }
  let!(:product) { create_product(person: user_account.person_id) }

  describe 'create' do
    before { sign_in(user_account) }

    context 'given valid params' do
      let(:params) { { form: { type: 'feature', description: 'ABC' } } }

      it do
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

    context 'given release' do
      before do
        append_release(product.id)
      end

      it do
        post product_issues_path(product_id: product.id.to_s, format: :js), params: { form: { type: 'feature', description: 'ABC', release_number: 2 } }

        pbl = ProductBacklogQuery.call(product.id.to_s)

        aggregate_failures do
          expect(pbl.releases[0].issues).to be_empty
          expect(pbl.releases[1].issues.map(&:description)).to eq ['ABC']
        end
      end
    end
  end

  describe 'edit' do
    before { sign_in(user_account) }

    it do
      issue = plan_issue(product.id, 'XYZ')
      append_acceptance_criteria(issue, %w(AC_123))

      get edit_issue_path(issue.id.to_s)

      aggregate_failures do
        expect(response.body).to include('XYZ')
        expect(response.body).to include('AC_123')
        expect(response.body).to include 'test-append-acceptance-criterion'
        expect(response.body).to include 'test-modify-acceptance-criterion-1'
        expect(response.body).to include 'test-remove-acceptance-criterion-1'
      end
    end

    context 'when wip' do
      it do
        issue = plan_issue(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1, assign: true)

        get edit_issue_path(issue.id.to_s)

        aggregate_failures do
          expect(response.body).to_not include 'test-append-acceptance-criterion'
          expect(response.body).to_not include 'test-modify-acceptance-criterion-1'
          expect(response.body).to_not include 'test-remove-acceptance-criterion-1'
        end
      end
    end
  end

  describe 'update' do
    before { sign_in(user_account) }

    let!(:issue) { plan_issue(product.id, 'ABC') }

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
    before { sign_in(user_account) }

    it do
      issue = plan_issue(product.id, 'YOHKYU')

      delete issue_path(issue.id)
      follow_redirect!

      expect(response.body).to_not include 'YOHKYU'
    end
  end

  it_behaves_like('sign_in_guard') { let(:r) { post product_issues_path(product_id: 1, format: :js) } }
  it_behaves_like('sign_in_guard') { let(:r) { get edit_issue_path(1) } }
  it_behaves_like('sign_in_guard') { let(:r) { patch issue_path(1, format: :js) } }
  it_behaves_like('sign_in_guard') { let(:r) { delete issue_path(1) } }
end
