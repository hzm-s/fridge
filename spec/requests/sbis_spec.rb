# typed: false
require 'rails_helper'

RSpec.describe 'sbis' do
  let!(:user_account) { sign_up }
  let!(:product) { create_product(person: user_account.person_id, roles: team_roles(:po)) }

  describe 'Create' do
    before { sign_in(user_account) }

    let!(:pbi) { add_pbi(product.id, 'KINOU', acceptance_criteria: %w(UKEIRE), size: 3, release: 1) }

    context 'sprint started' do
      before { start_sprint(product.id) }

      it do
        post product_sbis_path(product_id: product.id, format: :js), params: { pbi_id: pbi.id.to_s }

        aggregate_failures do
          expect(response.body).to include I18n.t('feedbacks.pbi.assign_to_sprint')
          expect(response.body).to include "test-pbi-#{pbi.id}-wip"

          get sprint_backlog_path(product.id)
          expect(response.body).to include "test-sbi-#{pbi.id}"
          expect(response.body).to include 'KINOU'
          expect(response.body).to include 'UKEIRE'
        end
      end
    end

    context 'sprint NOT started' do
      it do
        post product_sbis_path(product_id: product.id, format: :js), params: { pbi_id: pbi.id.to_s }
        follow_redirect!
        follow_redirect!
        expect(response.body).to include I18n.t('feedbacks.sprint.not_started')
      end
    end
  end

  describe 'Destroy' do
    before { sign_in(user_account) }

    let!(:pbi) { add_pbi(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1, assign: true) }

    it do
      delete product_sbi_path(product_id: product.id.to_s, id: pbi.id.to_s)

      aggregate_failures do
        follow_redirect!
        expect(response.body).to include I18n.t('feedbacks.pbi.revert_from_sprint')
        expect(response.body).to_not include "test-sbi-#{pbi.id}"

        get product_backlog_path(product.id)
        expect(response.body).to include "test-pbi-#{pbi.id}-ready"
      end
    end
  end

  it_behaves_like('sign_in_guard') { let(:r) { post product_sbis_path(product_id: 1, format: :js) } }
  it_behaves_like('sign_in_guard') { let(:r) { delete product_sbi_path(product_id: 1, id: 1) } }
end
