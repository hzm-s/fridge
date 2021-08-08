# typed: false
require 'domain_helper'

module Issue::Types
  RSpec.describe Task do
    describe '.initial_status' do
      it { expect(described_class.initial_status).to eq ::Issue::Statuses::Ready }
    end

    describe '.can_update_acceptance?' do
      context 'roles includes :update_task_acceptance' do
        it do
          roles = team_roles(:dev)
          expect(described_class.can_update_acceptance?(roles)).to be true
        end
      end

      context 'roles NOT includes :update_task_acceptance' do
        it do
          roles = team_roles(:sm)
          expect(described_class.can_update_acceptance?(roles)).to be false
        end
      end
    end

    describe '.can_accept?' do
      context 'roles includes :accept_task' do
        it do
          roles = team_roles(:po)
          expect(described_class.can_accept?(roles)).to be true
        end
      end

      context 'roles NOT includes :accept_task' do
        it do
          roles = team_roles(:sm)
          expect(described_class.can_accept?(roles)).to be false
        end
      end
    end

    describe '.satisfied?' do
      context 'when satisfied' do
        it do
          criteria = acceptance_criteria(%w(AC1 AC2 AC3), :all)
          expect(described_class.satisfied?(criteria)).to be true
        end
      end

      context 'when NOT satisfied' do
        it do
          criteria = acceptance_criteria(%w(AC1 AC2 AC3), [1, 3])
          expect(described_class.satisfied?(criteria)).to be false
        end
      end

      context 'when empty criteria' do
        it do
          criteria = acceptance_criteria([])
          expect(described_class.satisfied?(criteria)).to be true
        end
      end
    end

    describe '.must_have_acceptance_criteria?' do
      it { expect(described_class).to_not be_must_have_acceptance_criteria }
    end

    describe '.update_by_preparation?' do
      it { expect(described_class).to_not be_update_by_preparation }
    end

    describe '.accept_issue_activity' do
      it { expect(described_class.accept_issue_activity.to_s).to eq 'accept_task' }
    end
  end
end
