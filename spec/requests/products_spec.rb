# typed: false
require 'rails_helper'

RSpec.describe 'products' do
  let(:user_account) { sign_up }

  before do
    sign_in(user_account)
  end

  describe '#create' do
    context 'given valid params' do
      it do
        params = { form: { name: 'fridge', description: 'setsumei_of_product' } }
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
        params = { form: { name: '' } }
        post products_path(format: :js), params: params

        expect(response.body).to include I18n.t('errors.messages.blank')
      end
    end
  end

  describe '#index' do
    context 'when team NOT assigned' do
      it do
        product = create_product(owner: user_account.person_id)

        get products_path

        expect(response.body).to include new_team_path(product_id: product.id)
      end
    end

    context 'when team assigned' do
      it do
        dev = dev_member(sign_up_as_person.id)
        product = create_product(owner: user_account.person_id, members: [dev])

        get products_path

        aggregate_failures do
          team = Dao::Team.last

          expect(response.body).to include team_path(team.id)
        end
      end
    end
  end
end
