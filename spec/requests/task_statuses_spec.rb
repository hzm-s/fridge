# typed: false
require 'rails_helper'

describe '/sbi/:work_id/task_statuses' do
  let!(:user_account) { sign_up }
  let!(:product) { create_product(person: user_account.person_id, roles: team_roles(:dev)) }
  let!(:pbi) { add_pbi(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1, assign: true) }

  before do
    plan_task(pbi.id, %w(Task))
  end

  describe 'Start' do
    before { sign_in(user_account) }

    it do
      patch sbi_task_status_path(pbi_id: pbi.id, number: 1, by: :start_task, format: :js)
      expect(response.body).to include data_attr "test-task-status-#{pbi.id}-1", 'wip', true
    end
  end

  describe 'Suspend' do
    before { sign_in(user_account) }
    before { start_task(pbi.id, 1) }

    it do
      patch sbi_task_status_path(pbi_id: pbi.id, number: 1, by: :suspend_task, format: :js)
      expect(response.body).to include data_attr "test-task-status-#{pbi.id}-1", 'wait', true
    end
  end

  describe 'Resume' do
    before { sign_in(user_account) }

    before do
      start_task(pbi.id, 1)
      suspend_task(pbi.id, 1)
    end

    it do
      patch sbi_task_status_path(pbi_id: pbi.id, number: 1, by: :resume_task, format: :js)
      expect(response.body).to include data_attr "test-task-status-#{pbi.id}-1", 'wip', true
    end
  end

  describe 'Complete' do
    before { sign_in(user_account) }
    before { start_task(pbi.id, 1) }

    it do
      patch sbi_task_status_path(pbi_id: pbi.id, number: 1, by: :complete_task, format: :js)
      expect(response.body).to include data_attr "test-task-status-#{pbi.id}-1", 'done', true
    end
  end

  describe 'Available actions' do
    before { sign_in(user_account) }

    subject do
      get sprint_backlog_path(product.id)
      response.body
    end

    context 'when todo' do
      it do
        aggregate_failures do
          expect(subject).to include %Q(test-start-task-#{pbi.id}-1)
          expect(subject).to_not include %Q(test-complete-task-#{pbi.id}-1)
          expect(subject).to_not include %Q(test-resume-task-#{pbi.id}-1)
          expect(subject).to include data_attr "test-suspend-task-#{pbi.id}-1", false
          expect(subject).to include data_attr "test-update-task-#{pbi.id}-1", true
        end
      end
    end

    context 'when wip' do
      it do
        start_task(pbi.id, 1)
        aggregate_failures do
          expect(subject).to_not include %Q(test-start-task-#{pbi.id}-1)
          expect(subject).to include %Q(test-complete-task-#{pbi.id}-1)
          expect(subject).to_not include %Q(test-resume-task-#{pbi.id}-1)
          expect(subject).to include data_attr "test-suspend-task-#{pbi.id}-1", true
          expect(subject).to include data_attr "test-update-task-#{pbi.id}-1", true
        end
      end
    end

    context 'when wait' do
      it do
        start_task(pbi.id, 1)
        suspend_task(pbi.id, 1)
        aggregate_failures do
          expect(subject).to_not include %Q(test-start-task-#{pbi.id}-1)
          expect(subject).to_not include %Q(test-complete-task-#{pbi.id}-1)
          expect(subject).to include %Q(test-resume-task-#{pbi.id}-1)
          expect(subject).to include data_attr "test-suspend-task-#{pbi.id}-1", false
          expect(subject).to include data_attr "test-update-task-#{pbi.id}-1", true
        end
      end
    end

    context 'when done' do
      it do
        start_task(pbi.id, 1)
        complete_task(pbi.id, 1)
        aggregate_failures do
          expect(subject).to_not include %Q(test-start-task-#{pbi.id}-1)
          expect(subject).to_not include %Q(test-complete-task-#{pbi.id}-1)
          expect(subject).to_not include %Q(test-resume-task-#{pbi.id}-1)
          expect(subject).to include data_attr "test-suspend-task-#{pbi.id}-1", false
          expect(subject).to include data_attr "test-update-task-#{pbi.id}-1", false
        end
      end
    end
  end

  it_behaves_like('sign_in_guard') { let(:r) { patch sbi_task_status_path(pbi_id: 1, number: 1, by: :start_task, format: :js) } }
end
