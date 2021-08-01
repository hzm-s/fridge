# typed: false
require 'domain_helper'

module Issue::Types
  RSpec.describe Task do
    describe '.initial_status' do
      it { expect(described_class.initial_status).to eq ::Issue::Statuses::Ready }
    end

    describe '.can_update_acceptance?' do
      context 'status includes :update_task_acceptance, roles includes :update_task_acceptance' do
        it do
          status = Issue::Statuses::Wip
          roles = team_roles(:dev)
          expect(described_class.can_update_acceptance?(status, roles)).to be true
        end
      end

      context 'status includes :update_task_acceptance, roles NOT includes :update_task_acceptance' do
        it do
          status = Issue::Statuses::Wip
          roles = team_roles(:sm)
          expect(described_class.can_update_acceptance?(status, roles)).to be false
        end
      end

      context 'status NOT includes :update_task_acceptance, roles includes :update_task_acceptance' do
        it do
          status = Issue::Statuses::Ready
          roles = team_roles(:dev)
          expect(described_class.can_update_acceptance?(status, roles)).to be false
        end
      end

      context 'status NOT includes :update_task_acceptance, roles NOT includes :update_task_acceptance' do
        it do
          status = Issue::Statuses::Ready
          roles = team_roles(:sm)
          expect(described_class.can_update_acceptance?(status, roles)).to be false
        end
      end
    end

    describe '.must_have_acceptance_criteria?' do
      it { expect(described_class).to_not be_must_have_acceptance_criteria }
    end

    describe '.update_by_preparation?' do
      it { expect(described_class).to_not be_update_by_preparation }
    end
  end
end
