# typed: false
require 'rails_helper'

describe 'sprint_backlogs' do
  let!(:user_account_po) { sign_up }
  let!(:user_account_dev) { sign_up }
  let!(:user_account_sm) { sign_up }
  let!(:product) do
    create_product(
      person: user_account_po.person_id,
      roles: team_roles(:po),
      members: [
        team_member(user_account_dev.person_id, :dev),
        team_member(user_account_sm.person_id, :sm)
      ]
    )
  end

  context 'Sprint status' do
    before { sign_in(user_account_po) }

    context 'current sprint is NOT exists' do
      it do
        get sprint_backlog_path(product.id)
        follow_redirect!
        expect(response.body).to include 'test-start-sprint'
      end
    end

    context 'current sprint is exists' do
      let!(:sprint) { start_sprint(product.id) }

      it do
        get sprint_backlog_path(product.id)
        expect(response.body).to include "test-sprint-backlog-#{sprint.id}"
      end
    end
  end

  describe 'Permission of actions' do
    let!(:pbi) { add_pbi(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1, assign: true) }

    context 'when PO' do
      before { sign_in(user_account_po) }

      it do
        get sprint_backlog_path(product.id)

        aggregate_failures do
          expect(response.body).to include data_attr 'test-revert-item', 'true'
          #expect(response.body).to include data_attr 'test-accept-item', 'true'
          expect(response.body).to include 'test-change-item-priority'
        end
      end
    end

    context 'when Dev' do
      before { sign_in(user_account_dev) }

      it do
        get sprint_backlog_path(product.id)

        aggregate_failures do
          expect(response.body).to include data_attr 'test-revert-item', 'false'
          #expect(response.body).to include data_attr 'test-accept-item', 'false'
          expect(response.body).to_not include 'test-change-item-priority'
        end
      end
    end

    context 'when SM' do
      before { sign_in(user_account_sm) }

      it do
        get sprint_backlog_path(product.id)

        aggregate_failures do
          expect(response.body).to include data_attr 'test-revert-item', 'true'
          #expect(response.body).to include data_attr 'test-accept-item', 'false'
          expect(response.body).to include 'test-change-item-priority'
        end
      end
    end
  end

  xdescribe 'Work status' do
    let!(:pbi) { plan_pbi(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1, assign: true) }

    before { sign_in(user_account_po) }

    context 'when NOT accepted' do
      it do
        get sprint_backlog_path(product.id)

        aggregate_failures do
          expect(response.body).to include "test-task-list-#{pbi.id}"
          expect(response.body).to include data_attr 'test-revert-pbi', 'true'
        end
      end
    end

    context 'when accepted' do
      before { accept_work(pbi) }

      it do
        get sprint_backlog_path(product.id)

        aggregate_failures do
          expect(response.body).to include "test-task-list-#{pbi.id}"
          expect(response.body).to include data_attr 'test-revert-pbi', 'true'
        end
      end
    end
  end

  it_behaves_like('sign_in_guard') { let(:r) { get sprint_backlog_path(1) } }
end
