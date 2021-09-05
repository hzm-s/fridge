# typed: false
require 'rails_helper'

RSpec.describe 'products' do
  let(:user_account) { sign_up }

  describe '#create' do
    before { sign_in(user_account) }

    context 'given valid params' do
      it do
        params = { form: { name: 'fridge', description: 'setsumei_of_product', roles: ['', 'scrum_master', ''] } }
        post products_path(format: :js), params: params
        get products_path

        aggregate_failures do
          expect(response.body).to include 'fridge'
          expect(response.body).to include 'setsumei_of_product'
        end
      end
    end

    context 'given invalid params' do
      it do
        params = { form: { name: '', description: '', roles: ['', '', ''] } }
        post products_path(format: :js), params: params

        expect(response.body).to include I18n.t('errors.messages.blank')
      end
    end
  end

  it_behaves_like('sign_in_guard') { let(:r) { post products_path(format: :js) } }
end
