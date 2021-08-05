# typed: false
require 'domain_helper'

module Issue::Types
  RSpec.describe Feature do
    describe '.initial_status' do
      it { expect(described_class.initial_status).to eq ::Issue::Statuses::Preparation }
    end

    describe '.can_update_acceptance?' do
      context 'status includes :update_task_acceptance, roles includes :update_task_acceptance' do
        it do
          status = Issue::Statuses::Wip
          roles = team_roles(:po)
          expect(described_class.can_update_acceptance?(status, roles)).to be true
        end
      end

      context 'status includes :update_task_acceptance, roles NOT includes :update_task_acceptance' do
        it do
          status = Issue::Statuses::Wip
          roles = team_roles(:dev)
          expect(described_class.can_update_acceptance?(status, roles)).to be false
        end
      end

      context 'status NOT includes :update_task_acceptance, roles includes :update_task_acceptance' do
        it do
          status = Issue::Statuses::Ready
          roles = team_roles(:po)
          expect(described_class.can_update_acceptance?(status, roles)).to be false
        end
      end

      context 'status NOT includes :update_task_acceptance, roles NOT includes :update_task_acceptance' do
        it do
          status = Issue::Statuses::Ready
          roles = team_roles(:dev)
          expect(described_class.can_update_acceptance?(status, roles)).to be false
        end
      end
    end

    describe '.all_satisfied?' do
      context 'when all satisfied' do
        it do
          criteria = acceptance_criteria(%w(AC1 AC2 AC3), :all)
          expect(described_class.all_satisfied?(criteria)).to be true
        end
      end

      context 'when NOT all satisfied' do
        it do
          criteria = acceptance_criteria(%w(AC1 AC2 AC3), [1, 3])
          expect(described_class.all_satisfied?(criteria)).to be false
        end
      end
    end

    describe '.must_have_acceptance_criteria?' do
      it { expect(described_class).to be_must_have_acceptance_criteria }
    end

    describe '.update_by_preparation?' do
      it { expect(described_class).to be_update_by_preparation }
    end
  end
end
