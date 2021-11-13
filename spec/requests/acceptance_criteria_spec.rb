# typed: false
require 'rails_helper'

RSpec.describe 'acceptance_criteria' do
  let!(:user_account) { sign_up }
  let!(:product) { create_product(person: user_account.person_id) }
  let!(:pbi) { add_pbi(product.id) }

  describe 'create' do
    before { sign_in(user_account) }

    context 'given valid params' do
      it do
        post pbi_acceptance_criteria_path(pbi_id: pbi.id, format: :js), params: { form: { content: 'ukeire' } }
        follow_redirect!

        expect(response.body).to include 'ukeire'
      end
    end

    context 'given invalid params' do
      it do
        post pbi_acceptance_criteria_path(pbi_id: pbi.id, format: :js), params: { form: { content: '' } }
        expect(response.body).to include I18n.t('errors.messages.blank')
      end
    end
  end

  describe 'update' do
    before { sign_in(user_account) }

    before do
      append_acceptance_criteria(pbi, %w(Ukeire1 Ukeire2 Ukeire3))
    end

    context 'given valid params' do
      it do
        patch pbi_acceptance_criterion_path(pbi_id: pbi.id, number: 2, format: :js), params: { form: { content: 'Atarashii2' } }
        follow_redirect!

        expect(response.body).to include('Atarashii2')
      end
    end

    context 'given invalid params' do
      it do
        patch pbi_acceptance_criterion_path(pbi_id: pbi.id, number: 2, format: :js), params: { form: { content: '' } }

        expect(response.body).to include(I18n.t('errors.messages.blank'))
      end
    end
  end

  describe 'destroy' do
    before { sign_in(user_account) }

    before do
      append_acceptance_criteria(pbi, %w(ac_head ukeire_kijyun ac_tail))
    end

    it do
      delete pbi_acceptance_criterion_path(pbi_id: pbi.id, number: 2)
      follow_redirect!

      expect(response.body).to_not include 'ukeire_kijyun'
    end
  end

  it_behaves_like('sign_in_guard') { let(:r) { post pbi_acceptance_criteria_path(pbi_id: 1, format: :js) } }
  it_behaves_like('sign_in_guard') { let(:r) { patch pbi_acceptance_criterion_path(pbi_id: 1, number: 1, format: :js) } }
  it_behaves_like('sign_in_guard') { let(:r) { delete pbi_acceptance_criterion_path(pbi_id: 1, number: 1) } }
end
