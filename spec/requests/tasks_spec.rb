# typed: false
require 'rails_helper'

RSpec.describe '/sbi/:sbi_id/tasks' do
  let!(:user_account) { sign_up }
  let!(:product) { create_product(person: user_account.person_id, roles: team_roles(:dev)) }
  let!(:pbi) { add_pbi(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1, assign: true) }

  describe 'create' do
    before { sign_in(user_account) }

    context 'given valid params' do
      it do
        post sbi_tasks_path(sbi_id: pbi.id, format: :js), params: { form: { content: 'Design API' } }
        get sprint_backlog_path(product.id)
        expect(response.body).to include 'Design API'
        expect(response.body).to include %Q(test-task-status-#{pbi.id}-1="todo")
      end
    end

    context 'given invalid params' do
      it do
        post sbi_tasks_path(sbi_id: pbi.id, format: :js), params: { form: { content: '' } }

        expect(response.body).to include(I18n.t('errors.messages.blank'))
      end
    end
  end

  xdescribe 'update' do
    before { sign_in(user_account) }

    before do
      plan_task(pbi.id, %w(Tasuku1 Tasuku2 Tasuku3))
    end

    context 'given valid params' do
      it do
        patch sbi_task_path(sbi_id: pbi.id, number: 2, format: :js), params: { form: { content: 'Yarukoto' } }

        aggregate_failures do
          expect(response.body).to include 'Yarukoto'
          expect(response.body).to_not include 'Tasuku2'
        end
      end
    end

    context 'given invalid params' do
      it do
        patch sbi_task_path(sbi_id: pbi.id, number: 2, format: :js), params: { form: { content: '' } }

        expect(response.body).to include(I18n.t('errors.messages.blank'))
      end
    end
  end

  xdescribe 'destroy' do
    before { sign_in(user_account) }

    before do
      plan_task(pbi.id, %w(Tasuku1 Tasuku2 Tasuku3))
    end

    it do
      delete sbi_task_path(sbi_id: pbi.id, number: 2, format: :js)

      expect(response.body).to_not include 'Tasuku2'
    end
  end

  it_behaves_like('sign_in_guard') { let(:r) { post sbi_tasks_path(sbi_id: 1, format: :js) } }
  it_behaves_like('sign_in_guard') { let(:r) { patch sbi_task_path(sbi_id: 1, number: 2, format: :js) } }
  it_behaves_like('sign_in_guard') { let(:r) { delete sbi_task_path(sbi_id: 1, number: 2, format: :js) } }
end
